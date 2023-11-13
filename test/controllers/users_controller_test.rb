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

  test "curators should redirect to home page" do
    sign_in users(:curator)
    get users_url
    assert_redirected_to root_url
  end
end
