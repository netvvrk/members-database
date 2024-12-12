require "securerandom"

class WebhookHandler
  class << self
    def handle_payload(event)
      if Rails.configuration.x.chargebee.log_webhook_events
        Rails.logger.info(event)
      end

      case event.event_type
      # when "payment_succeeded"
      #   upgrade_monthly_user(event)
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
      unless user
        Rails.logger.error("User not found for #{customer.id}")
        return
      end

      active = Util.subscription_is_annual_or_founding(event.content.subscription)

      user.send_welcome_email if active && Rails.configuration.x.user_creation_send_email

      user.active = true
      user.save
    end

    def deactivate_user(event)
      customer = event.content.customer
      user = User.find_by(cb_customer_id: customer.id)
      return true unless user

      user.active = false
      user.save
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
      name = [customer.first_name, customer.last_name].compact.join(" ")

      u = User.create(
        email: customer.email,
        role: "artist",
        password: password,
        password_confirmation: password,
        cb_customer_id: customer.id
      )
      if u.valid?
        u.send_welcome_email if Rails.configuration.x.user_creation_send_email
        u.profile.name = name
        u.save
        true
      else
        Rails.logger.error("User creation for #{customer.id} failed -- #{u.errors.messages}")
      end
    end

    def upgrade_monthly_user(event)
      return true if Util.subscription_is_annual_or_founding(event.content.subscription)
      started_at = event.content.subscription.started_at
      if 2.years.ago.to_i > started_at
        activate_user(event)
      end
    end
  end
end
