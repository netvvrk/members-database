require "test_helper"

class ArtworksControllerTest < ActionDispatch::IntegrationTest
  test "successful post" do
    post webhook_chargebee_url
    assert_response :success
  end
end
