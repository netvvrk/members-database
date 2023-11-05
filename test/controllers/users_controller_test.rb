require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
    @user = users(:artist)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end
end
