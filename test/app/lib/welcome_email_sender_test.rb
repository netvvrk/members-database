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
    assert_difference "WelcomeEmail.count", 0 do
      WelcomeEmailSender.send(users(:artist))
    end
  end

  test "send_scheduled_emails sends email when record has send_at in the past" do
    user = users(:artist)
    WelcomeEmailSender.send(user)
    travel_to 1.day.from_now
    WelcomeEmailSender.expects(:sendgrid_send).once
    WelcomeEmailSender.send_scheduled_emails
  end
end
