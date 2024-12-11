class Util
  class << self
    def subscription_is_annual_or_founding(subscription)
      subscription_types = subscription.subscription_items.map(&:item_price_id)
      subscription_types.any? { |t| t =~ /Annual|Founding|Netvvrk-Payment-Plan-USD-Every-6-months/ }
    end
  end
end
