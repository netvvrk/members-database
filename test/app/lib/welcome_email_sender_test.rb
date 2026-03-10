require "test_helper"

class WelcomeEmailSenderTest < ActiveSupport::TestCase
  test "sends email when user_creation_send_email flag is true" do
    with_config(:user_creation_send_email, true) do
      WelcomeEmailSender.expects(:sendgrid_send).once
      WelcomeEmailSender.send(users(:artist))
    end
  end

  test "do not send email unless user_creation_send_email flag is true" do
    with_config(:user_creation_send_email, false) do
      WelcomeEmailSender.expects(:sendgrid_send).never
      WelcomeEmailSender.send(users(:artist))
    end
  end
end
