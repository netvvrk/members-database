require "test_helper"

class WelcomeEmailSenderTest < ActiveSupport::TestCase
  test "creates a welcome_email record when user_creation_send_email flag is true" do
    user = users(:artist)
    with_config(:user_creation_send_email, true) do
      assert_difference "WelcomeEmail.count", 1 do
        WelcomeEmailSender.send(user)
      end
      assert_not_nil user.reload.welcome_email
    end
  end

  test "resending updates the existing welcome_email record instead of raising a uniqueness error" do
    user = users(:artist)
    with_config(:user_creation_send_email, true) do
      WelcomeEmailSender.send(user)
      welcome_email = user.reload.welcome_email
      welcome_email.update!(sent_at: Time.now)

      travel_to 1.hour.from_now
      assert_difference "WelcomeEmail.count", 0 do
        WelcomeEmailSender.send(user)
      end
      welcome_email.reload
      assert_nil welcome_email.sent_at
      assert_in_delta Time.now.to_i, welcome_email.send_at.to_i, 1
    end
  end

  test "does not create a welcome_email record if user_creation_send_email flag is false" do
    with_config(:user_creation_send_email, false) do
      assert_difference "WelcomeEmail.count", 0 do
        WelcomeEmailSender.send(users(:artist))
      end
    end
  end

  test "does not create a welcome_email record when user.active is false" do
    user = users(:artist)
    user.update!(active: false)
    with_config(:user_creation_send_email, true) do
      assert_difference "WelcomeEmail.count", 0 do
        WelcomeEmailSender.send(users(:artist))
      end
    end
  end

  test "send_scheduled_emails sends email when record has send_at in the past" do
    with_config(:user_creation_send_email, true) do
      user = users(:artist)
      WelcomeEmailSender.send(user)
      travel_to 1.hour.from_now
      WelcomeEmailSender.expects(:sendgrid_send).once
      WelcomeEmailSender.send_scheduled_emails
    end
  end

  test "send_scheduled_emails sends email in the future user_creation_email_delay is set" do
    with_config(:user_creation_send_email, true) do
      with_config(:user_creation_email_delay, 7) do
        user = users(:artist)
        WelcomeEmailSender.send(user)
        travel_to 7.days.from_now + 1.hour
        WelcomeEmailSender.expects(:sendgrid_send).once
        WelcomeEmailSender.send_scheduled_emails
      end
    end
  end

  test "send_scheduled_emails doesn't send email until user_creation_email_delay has passed" do
    with_config(:user_creation_send_email, true) do
      with_config(:user_creation_email_delay, 7) do
        user = users(:artist)
        WelcomeEmailSender.send(user)
        travel_to 6.days.from_now
        WelcomeEmailSender.expects(:sendgrid_send).never
        WelcomeEmailSender.send_scheduled_emails
      end
    end
  end

  test "send_scheduled_emails does not mark welcome_email as sent when sendgrid_send fails" do
    with_config(:user_creation_send_email, true) do
      user = users(:artist)
      WelcomeEmailSender.send(user)
      travel_to 1.hour.from_now
      WelcomeEmailSender.stubs(:sendgrid_send).raises("boom")
      WelcomeEmailSender.send_scheduled_emails
      assert_nil user.reload.welcome_email.sent_at
    end
  end

  test "sendgrid_send raises when SendGrid returns a non-2xx response" do
    response = Struct.new(:status_code, :body).new("403", "Forbidden")
    post_double = mock
    post_double.stubs(:post).returns(response)
    send_double = mock
    send_double.stubs(:_).with("send").returns(post_double)
    mail_double = mock
    mail_double.stubs(:mail).returns(send_double)
    client_double = mock
    client_double.stubs(:client).returns(mail_double)
    SendGrid::API.stubs(:new).returns(client_double)

    assert_raises(RuntimeError) { WelcomeEmailSender.sendgrid_send(SendGrid::Mail.new) }
  end
end
