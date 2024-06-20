require "securerandom"

class WebhookHandler
  class << self
    def handle_payload(payload)
      data = JSON.parse(payload)

      case data["event_type"]
      when "subscription_created"
        handle_subscription(data)
      else
        false
      end
    end

    def handle_subscription(payload)
      customer = payload["content"]["customer"]
      password = SecureRandom.hex

      u = User.create(
        email: customer["email"],
        first_name: customer["first_name"],
        last_name: customer["last_name"],
        role: "artist",
        password: password,
        password_confirmation: password
      )
      if u.valid?
        u.send_reset_password_instructions
        true
      else
        Rails.logger.error("User creation for #{customer["id"]} failed -- #{u.errors.messages}")
      end
    end
  end
end
