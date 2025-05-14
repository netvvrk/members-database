class Util
  class << self
    ANNUAL_PLANS = {
      "Netvvrk-Annual-USD-Yearly" => 1,
      "Netvvrk-Annual-877" => 1,
      "Netvvrk-Payment-Plan-USD-Every-6-months" => 1,
      "Netvvrk-Payment-Plan-4385" => 1,
      "Founding-Member-Annual-USD-Yearly" => 1,
      "Netvvrk-V2-01-USD-Yearly" => 1,
      "Netvvrk-V2-06-USD-Every-6-months" => 1,
      "Netvvrk-V2-05-USD-Yearly" => 1
    }

    def subscription_is_annual_or_founding(subscription)
      subscription_types = subscription&.subscription_items&.map(&:item_price_id) || []
      subscription_types.any? { |t| ANNUAL_PLANS.key?(t) }
    end

    def check_subscription
      site = ENV.fetch("PROD_CHARGEBEE_SITE")
      key = ENV.fetch("PROD_CHARGEBEE_API_KEY")
      ChargeBee.configure({api_key: key, site: site})

      File.readlines(File.join(ENV.fetch("HOME"), "check-emails.txt")).each do |email|
        email.chomp!
        break if email.blank?

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
          print subscription&.subscription_items&.map(&:item_price_id)
        end
        puts ""
      end
    end

    def check_inactive_accounts
      File.readlines(File.join(ENV.fetch("HOME"), "check-emails.txt")).each do |email|
        email.chomp!
        break if email.blank?
        subscription = check_subscription_for_email(email)
        print email, " -- #{subscription_is_annual_or_founding(subscription)}\n"
      end
    end

    def check_subscription_for_email(email)
      site = ENV.fetch("PROD_CHARGEBEE_SITE")
      key = ENV.fetch("PROD_CHARGEBEE_API_KEY")
      ChargeBee.configure({api_key: key, site: site})
      resp = ChargeBee::Customer.list("email[is]" => email)
      return nil if resp.length.zero?

      customer_ids = resp.map(&:customer).map(&:id)
      resp = ChargeBee::Subscription.list("customer_id[in]" => customer_ids)
      length = resp.length
      return nil if length.zero?

      resp.map(&:subscription).find { |i| i.status == "active" }
    end

    def deleted_old_webhook_events
      ChargebeeEvent.where("created_at < ?", 3.months.ago).delete_all
    end
  end
end
