class Util
  class << self
    def subscription_is_annual(subscription)
      subscription_types = subscription.subscription_items.map(&:item_price_id)
      subscription_types.any? { |t| t =~ /Annual/ }
    end
  end
end
