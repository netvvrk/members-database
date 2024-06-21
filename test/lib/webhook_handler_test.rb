require "test_helper"

class WebhookHandlerTest < ActiveSupport::TestCase
  test "subscription created" do
    payload = File.read(Rails.root.join("test", "fixtures", "files", "subscription_created.json"))
    event = ChargeBee::Event.deserialize(payload)

    assert_difference "User.count" do
      assert WebhookHandler.handle_payload(event)
    end
  end
end
