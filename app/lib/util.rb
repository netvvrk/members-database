class Util
  class << self
    def subscription_is_annual_or_founding(subscription)
      subscription_types = subscription.subscription_items.map(&:item_price_id)
      subscription_types.any? { |t| t =~ /Annual|Founding|Netvvrk-Payment-Plan-USD-Every-6-months/ }
    end

    def check_subscription
      site = ENV.fetch("PROD_CHARGEBEE_SITE")
      key = ENV.fetch("PROD_CHARGEBEE_API_KEY")
      ChargeBee.configure({api_key: key, site: site})

      File.readlines(File.join(ENV.fetch("HOME"), "check-emails.txt")).each do |email|
        email.chomp!
        last if email.blank?

        print email, " -- "
        resp = ChargeBee::Customer.list("email[is]" => email)
        if resp.length.zero?
          puts "NOT FOUND"
          next
        end

        customer_ids = resp.map(&:customer).map(&:id)

        resp = ChargeBee::Subscription.list("customer_id[in]" => customer_ids)
        length = resp.length
        raise "Subscription not found" if length.zero?

        subscription = resp.map(&:subscription).find { |i| i.status == "active" }
        should_receive = subscription_is_annual_or_founding(subscription)

        print "Should receive email: #{should_receive}"
        if !should_receive
          print subscription.subscription_items.map(&:item_price_id)
        end
        puts ""
      end
    end
  end
end
