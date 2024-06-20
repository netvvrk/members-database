class WebhookHandler
  class << self
    def handle_payload(payload)
      data = JSON.parse(payload)

      case data["event_type"]
      when "subscription_created"
        handle_subscription(payload)
      else
        false
      end
    end

    def handle_subscription(payload)
      true
    end
  end
end
