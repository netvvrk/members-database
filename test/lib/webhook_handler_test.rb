require "test_helper"

class WebhookHandlerTest < ActiveSupport::TestCase
  test "subscription created" do
    payload = File.read(Rails.root.join("test", "fixtures", "files", "subscription_created.json"))
    assert WebhookHandler.handle_payload(payload)
  end
end
