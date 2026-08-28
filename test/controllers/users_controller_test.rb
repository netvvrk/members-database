require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "admins should get index" do
    sign_in users(:admin)
    get users_url
    assert_response :success
  end

  test "should redirect if not logged in" do
    get users_url
    assert_response :redirect
  end

  test "artists should redirect to home page" do
    sign_in users(:artist)
    get users_url
    assert_redirected_to root_url
  end

  test "send_welcome_email redirects with a notice when the email sends successfully" do
    sign_in users(:admin)
    user = users(:artist)
    WelcomeEmailSender.expects(:send).with(user, immediate: true).returns(WelcomeEmail.new(sent_at: Time.now))
    get send_welcome_email_user_path(user)
    assert_redirected_to users_path
    assert_equal "Welcome email sent to #{user.email}", flash[:notice]
  end

  test "send_welcome_email redirects with an alert when the email fails to send" do
    sign_in users(:admin)
    user = users(:artist)
    WelcomeEmailSender.expects(:send).with(user, immediate: true).returns(WelcomeEmail.new(sent_at: nil))
    get send_welcome_email_user_path(user)
    assert_redirected_to users_path
    assert_equal "Failed to send welcome email to #{user.email}", flash[:alert]
  end
end
