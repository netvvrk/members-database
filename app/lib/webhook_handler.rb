require "securerandom"

class WebhookHandler
  class << self
    def handle_payload(event)
      case event.event_type
      when "payment_succeeded"
        payment_succeeded(event)
      when "subscription_cancelled"
        deactivate_user(event)
      when "subscription_changed"
        subscription_change(event)
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

    # monthly subscribers with at least 2 years of payments get activated
    def payment_succeeded(event)
      subscription = event.content.subscription
      return if Util.subscription_is_annual_or_founding(subscription)

      if 2.years.ago.to_i > subscription.started_at
        activate_user(event)
      end
    end

    def subscription_change(event)
      if Util.subscription_is_annual_or_founding(event.content.subscription)
        activate_user(event)
      else
        deactivate_user(event)
      end
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
