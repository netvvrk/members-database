require "test_helper"

class ArtworksControllerTest < ActionDispatch::IntegrationTest
  test "forbidden without basic auth" do
    post webhook_chargebee_url
    assert_response :unauthorized
  end

  test "subscription created post" do
    payload = File.read(Rails.root.join("test", "fixtures", "files", "subscription_created.json"))
    data = JSON.parse(payload)
    assert_difference "User.count" do
      post webhook_chargebee_url,
        params: data, as: :json,
        headers: {Authorization: ActionController::HttpAuthentication::Basic.encode_credentials("test-user", "password"),
                  "Content-Type": "application/json"}
    end
    assert_response :success
  end
end
