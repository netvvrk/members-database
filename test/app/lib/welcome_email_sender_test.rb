require "test_helper"

class WelcomeEmailSenderTest < ActiveSupport::TestCase
  test "sends email when user_creation_send_email flag is true and delay days are 0" do
    with_config(:user_creation_email_delay, 0) do
      with_config(:user_creation_send_email, true) do
        WelcomeEmailSender.expects(:sendgrid_send).once
        WelcomeEmailSender.send(users(:artist))
      end
    end
  end

  test "do not send email immediately if delay days are > 0" do
    with_config(:user_creation_email_delay, 1) do
      with_config(:user_creation_send_email, true) do
        WelcomeEmailSender.expects(:sendgrid_send).never
        WelcomeEmailSender.send(users(:artist))
      end
    end
  end

  test "sends email when delay > 0 and send_welcome_email_at is in the past" do
    with_config(:user_creation_email_delay, 7) do
      with_config(:user_creation_send_email, true) do
        user = users(:artist)
        user.update!(send_welcome_email_at: 1.day.ago)
        WelcomeEmailSender.expects(:sendgrid_send).once
        WelcomeEmailSender.send(user)
      end
    end
  end

  test "does not send email when delay > 0 and send_welcome_email_at is in the future" do
    with_config(:user_creation_email_delay, 7) do
      with_config(:user_creation_send_email, true) do
        user = users(:artist)
        user.update!(send_welcome_email_at: 1.day.from_now)
        WelcomeEmailSender.expects(:sendgrid_send).never
        WelcomeEmailSender.send(user)
      end
    end
  end

  test "does not overwrite send_welcome_email_at when already set" do
    with_config(:user_creation_email_delay, 7) do
      with_config(:user_creation_send_email, true) do
        user = users(:artist)
        original_time = 3.days.from_now
        user.update!(send_welcome_email_at: original_time)
        WelcomeEmailSender.send(user)
        assert_equal original_time.to_i, user.reload.send_welcome_email_at.to_i
      end
    end
  end

  test "sets send_welcome_email_at on user when delay > 0" do
    with_config(:user_creation_email_delay, 7) do
      with_config(:user_creation_send_email, true) do
        user = users(:artist)
        WelcomeEmailSender.send(user)
        assert_not_nil user.reload.send_welcome_email_at
      end
    end
  end

  test "sets welcome_email_sent_at after sending" do
    with_config(:user_creation_email_delay, 0) do
      with_config(:user_creation_send_email, true) do
        WelcomeEmailSender.stubs(:sendgrid_send)
        user = users(:artist)
        WelcomeEmailSender.send(user)
        assert_not_nil user.reload.welcome_email_sent_at
      end
    end
  end

  test "do not send email unless user_creation_send_email flag is true" do
    with_config(:user_creation_send_email, false) do
      WelcomeEmailSender.expects(:sendgrid_send).never
      WelcomeEmailSender.send(users(:artist))
    end
  end

  test "do not send email when user.active is false" do
    WelcomeEmailSender.expects(:sendgrid_send).never
    user = users(:artist)
    user.update!(active: false)
    WelcomeEmailSender.expects(:sendgrid_send).never
    WelcomeEmailSender.send(users(:artist))
  end

  test "do not send email when user.welcome_email_sent_at is set" do
    WelcomeEmailSender.expects(:sendgrid_send).never
    user = users(:artist)
    user.update!(welcome_email_sent_at: 1.day.ago)
    WelcomeEmailSender.expects(:sendgrid_send).never
    WelcomeEmailSender.send(users(:artist))
  end

  test "send_delayed_emails sends email to user whose send_welcome_email_at has passed" do
    with_config(:user_creation_send_email, true) do
      user = users(:artist)
      user.update!(send_welcome_email_at: 1.day.ago)
      WelcomeEmailSender.expects(:sendgrid_send).once
      WelcomeEmailSender.send_delayed_emails
    end
  end

  test "send_delayed_emails skips user whose send_welcome_email_at is in the future" do
    with_config(:user_creation_send_email, true) do
      user = users(:artist)
      user.update!(send_welcome_email_at: 1.day.from_now)
      WelcomeEmailSender.expects(:sendgrid_send).never
      WelcomeEmailSender.send_delayed_emails
    end
  end

  test "send_delayed_emails skips user whose welcome_email_sent_at is set" do
    with_config(:user_creation_send_email, true) do
      user = users(:artist)
      user.update!(send_welcome_email_at: 1.day.ago, welcome_email_sent_at: 1.hour.ago)
      WelcomeEmailSender.expects(:sendgrid_send).never
      WelcomeEmailSender.send_delayed_emails
    end
  end

  test "send_delayed_emails skips inactive users" do
    with_config(:user_creation_send_email, true) do
      user = users(:artist)
      user.update!(send_welcome_email_at: 1.day.ago, active: false)
      WelcomeEmailSender.expects(:sendgrid_send).never
      WelcomeEmailSender.send_delayed_emails
    end
  end
end
