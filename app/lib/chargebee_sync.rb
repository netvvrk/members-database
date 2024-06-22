class ChargebeeSync
  def initialize
    config = Rails.configuration.x.chargebee
    @client = ChargeBee.configure({api_key: config.api_key, site: config.site})
  end

  def run
    search_condition = {:limit => 100, "status[not_in]" => "[cancelled,non_renewing]"}
    loop do
      resp = ChargeBee::Subscription.list(search_condition)
      resp.each do |entry|
        next unless Util.subscription_is_annual(entry.subscription)
        create_user(entry.customer)
      end
      if resp.next_offset
        search_condition[:offset] = resp.next_offset
      else
        break
      end
    end
    puts "end"
  end

  def create_user(customer)
    puts customer.email
    cb_id = customer.id
    return if User.exists?(["email = ? or cb_customer_id = ?", customer.email, cb_id])

    password = SecureRandom.alphanumeric(12)
    u = User.create!(
      cb_customer_id: cb_id,
      email: customer.email,
      first_name: customer.first_name,
      last_name: customer.last_name,
      password: password,
      password_confirmation: password,
      role: "artist"
    )
    u.send_reset_password_instructions
  end
end
