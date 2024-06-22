require "test_helper"

class WebhookHandlerTest < ActiveSupport::TestCase
  test "subscription created" do
    payload = File.read(Rails.root.join("test", "fixtures", "files", "subscription_created.json"))
    event = ChargeBee::Event.deserialize(payload)

    assert_difference "User.count" do
      assert WebhookHandler.handle_payload(event)
    end
  end

  test "subscripton cancelled" do
    payload = File.read(Rails.root.join("test", "fixtures", "files", "subscription_cancelled.json"))
    event = ChargeBee::Event.deserialize(payload)

    user = users(:artist)
    assert(user.active)

    assert WebhookHandler.handle_payload(event)
    refute(user.reload.active)
  end

  test "subscripton paused" do
    payload = File.read(Rails.root.join("test", "fixtures", "files", "subscription_paused.json"))
    event = ChargeBee::Event.deserialize(payload)

    user = users(:artist)
    artwork = create_artwork(user)

    assert(user.active)
    assert(artwork.active)
    assert WebhookHandler.handle_payload(event)
    refute(user.reload.active)
    refute(artwork.reload.active)
  end

  test "subscripton reactivated" do
    payload = File.read(Rails.root.join("test", "fixtures", "files", "subscription_reactivated.json"))
    event = ChargeBee::Event.deserialize(payload)

    user = users(:artist)
    user.active = false
    user.save

    assert WebhookHandler.handle_payload(event)
    assert(user.reload.active)
  end

  test "subscripton resumed" do
    payload = File.read(Rails.root.join("test", "fixtures", "files", "subscription_resumed.json"))
    event = ChargeBee::Event.deserialize(payload)

    user = users(:artist)
    artwork = create_artwork(user)
    user.active = false
    user.save

    refute(artwork.reload.active)

    assert WebhookHandler.handle_payload(event)
    assert(user.reload.active)
    assert(artwork.reload.active)
  end
end
