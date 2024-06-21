require "test_helper"

class ArtworksControllerTest < ActionDispatch::IntegrationTest
  test "forbidden without basic auth" do
    post webhook_chargebee_url
    assert_response :unauthorized
  end

  test "subscription created post" do
    payload = File.read(Rails.root.join("test", "fixtures", "files", "subscription_created.json"))
    post webhook_chargebee_url,
      params: JSON.parse(payload),
      headers: {Authorization: ActionController::HttpAuthentication::Basic.encode_credentials("test-user", "password")}
    assert_response :success
  end
end
