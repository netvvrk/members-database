require "securerandom"

class WebhookHandler
  class << self
    def handle_payload(event)
      begin
        cb_event = ChargebeeEvent.new(
          event_id: event.id,
          created_at: event.occurred_at,
          event_type: event.event_type,
          user_email: event.content.customer&.email,
          content: event.content
        )
        unless cb_event.save
          Rails.logger.error("ChargebeeEvent failed: #{cb_event.errors.messages}")
          return false
        end
      rescue ActiveRecord::RecordNotUnique
        Rails.logger.error("Skipped duplicate ChargebeeEvent #{event.id}")
        return false
      end

      user = find_user(event)
      if need_user(event) && !user
        Rails.logger.error("User not found for #{event.content.customer.email}")
        return true
      end

      case event.event_type
      # when "payment_succeeded"
      #   upgrade_monthly_user(user, event)
      when "subscription_cancelled"
        deactivate_user(user)
      when "subscription_changed"
        subscription_change(user, event)
      when "subscription_created"
        subscription_create(event)
      when "subscription_paused"
        deactivate_user(user)
      # when "subscription_reactivated"
      #   activate_user(event)
      # when "subscription_resumed"
      #   activate_user(event)
      else
        false
      end
    end

    private

    def find_user(event)
      customer = event.content.customer
      User.find_by(cb_customer_id: customer.id)
    end

    # events that need a user for an update
    def need_user(event)
      event.event_type != "subscription_created"
    end

    def activate_user(user, event)
      active = Util.subscription_is_annual_or_founding(event.content.subscription)

      user.send_welcome_email if active && Rails.configuration.x.user_creation_send_email

      user.active = true
      user.save
    end

    def deactivate_user(user)
      user.active = false
      user.save
    end

    def subscription_change(user, event)
      if Util.subscription_is_annual_or_founding(event.content.subscription)
        user = find_user(event)
        activate_user(user, event)
      else
        deactivate_user(user)
      end
    end

    # TODO: handle creation for existing user
    def subscription_create(event)
      active = Util.subscription_is_annual_or_founding(event.content.subscription)

      customer = event.content.customer
      password = SecureRandom.hex
      name = [customer.first_name, customer.last_name].compact.join(" ")

      u = User.create(
        email: customer.email,
        role: "artist",
        password: password,
        password_confirmation: password,
        cb_customer_id: customer.id,
        active: active
      )
      if u.valid?
        u.send_welcome_email if active && Rails.configuration.x.user_creation_send_email
        u.profile.name = name
        u.save
        true
      else
        Rails.logger.error("User creation for #{customer.id} failed -- #{u.errors.messages}")
      end
    end

    def upgrade_monthly_user(user, event)
      return true if Util.subscription_is_annual_or_founding(event.content.subscription)
      started_at = event.content.subscription.started_at
      if 2.years.ago.to_i > started_at
        activate_user(user)
      end
    end
  end
end
