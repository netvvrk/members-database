require "test_helper"

class WebhookHandlerTest < ActiveSupport::TestCase
  test "subscription created" do
    payload = File.read(Rails.root.join("test", "fixtures", "files", "subscription_created.json"))
    assert_difference "User.count" do
      assert WebhookHandler.handle_payload(payload)
    end
  end
end
