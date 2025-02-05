require "test_helper"

class MainControllerTest < ActionDispatch::IntegrationTest
  test "get index" do
    get root_url
    assert_response :success
  end

  test "get index with non-numeric price query does not crash" do
    get root_url, params: {min_price: 100, max_price: "test"}
    assert_response :success
  end
end
