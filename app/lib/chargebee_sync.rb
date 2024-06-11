class ChargebeeSync
  def initialize
    api_key = ENV.fetch("CHARGEBEE_API_KEY")
    site = ENV.fetch("CHARGEBEE_SITE")
    @max = ENV.fetch("MAX", 0).to_i

    @client = ChargeBee.configure({api_key: api_key, site: site})
  end

  def run
    limit_max = @max > 0
    max_reached = false
    total_created = 0
    search_condition = {:limit => 100, "status[not_in]" => "[cancelled,non_renewing]"}
    resp = ChargeBee::Subscription.list(search_condition)
    while !max_reached && offset = resp.next_offset
      resp.each do |entry|
        subscription = entry.subscription
        customer = entry.customer
        cb_id = customer.id

        next if User.exists?(cb_customer_id: cb_id)
        puts "#{cb_id} - #{subscription.status}"

        password = SecureRandom.alphanumeric(12)
        User.create!(
          cb_customer_id: cb_id,
          email: customer.email,
          first_name: customer.first_name,
          last_name: customer.last_name,
          password: password,
          password_confirmation: password,
          role: "artist"
        )
        total_created += 1
        if limit_max && total_created == @max
          max_reached = true
          break
        end
      end
      search_condition[:offset] = offset
      resp = ChargeBee::Subscription.list(search_condition) if !max_reached
    end
  end
end
