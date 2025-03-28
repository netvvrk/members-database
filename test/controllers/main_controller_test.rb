require "test_helper"

class MainControllerTest < ActionDispatch::IntegrationTest
  test "home page" do
    get root_url
    assert_response :success
  end

  test "should load without errors on a search with 0 results" do
    get root_url, params: { search: "asdf"}
    assert_response :success
  end
end
