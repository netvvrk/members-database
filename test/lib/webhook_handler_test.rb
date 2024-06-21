require "test_helper"

class WebhookHandlerTest < ActiveSupport::TestCase
  test "subscription created" do
    payload = File.read(Rails.root.join("test", "fixtures", "files", "subscription_created.json"))
    event = ChargeBee::Event.deserialize(payload)

    assert_difference "User.count" do
      assert WebhookHandler.handle_payload(event)
    end
  end

  test "subscripton paused" do
    payload = File.read(Rails.root.join("test", "fixtures", "files", "subscription_paused.json"))
    event = ChargeBee::Event.deserialize(payload)
    customer = event.content.customer

    user = User.create(
      email: customer.email,
      first_name: customer.first_name,
      last_name: customer.last_name,
      role: "artist",
      password: "password",
      password_confirmation: "password",
      cb_customer_id: customer.id
    )

    assert(user.reload.active)
    assert WebhookHandler.handle_payload(event)
    assert_equal(user.reload.active, false)
  end
end
