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

  test "sends email when delay > 0 but send_welcome_email_at has already been set" do
    with_config(:user_creation_email_delay, 7) do
      with_config(:user_creation_send_email, true) do
        user = users(:artist)
        user.update!(send_welcome_email_at: 1.day.ago)
        WelcomeEmailSender.expects(:sendgrid_send).once
        WelcomeEmailSender.send(user)
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
