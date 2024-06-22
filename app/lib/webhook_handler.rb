require "securerandom"

class WebhookHandler
  class << self
    def handle_payload(event)
      case event.event_type
      when "subscription_cancelled"
        deactivate_user(event)
      when "subscription_created"
        subscription_create(event)
      when "subscription_paused"
        deactivate_user(event)
      when "subscription_reactivated"
        activate_user(event)
      when "subscription_resumed"
        activate_user(event)
      else
        false
      end
    end

    private

    def activate_user(event)
      customer = event.content.customer
      user = User.find_by(cb_customer_id: customer.id)
      user.active = true
      user.save
    end

    def deactivate_user(event)
      customer = event.content.customer
      user = User.find_by(cb_customer_id: customer.id)
      user.active = false
      user.save
    end

    def subscription_create(event)
      return true unless Util.subscription_is_annual_or_founding(event.content.subscription)

      customer = event.content.customer
      password = SecureRandom.hex

      u = User.create(
        email: customer.email,
        first_name: customer.first_name,
        last_name: customer.last_name,
        role: "artist",
        password: password,
        password_confirmation: password,
        cb_customer_id: customer.id
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
