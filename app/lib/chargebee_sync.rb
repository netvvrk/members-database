class ChargebeeSync
  def initialize
    config = Rails.configuration.x.chargebee
    ChargeBee.configure({api_key: config.api_key, site: config.site})
  end

  def run
    search_condition = {:limit => 100, "status[not_in]" => "[cancelled,non_renewing]"}
    loop do
      resp = ChargeBee::Subscription.list(search_condition)
      resp.each do |entry|
        create_user(entry)
      end
      if resp.next_offset
        search_condition[:offset] = resp.next_offset
      else
        break
      end
    end
    puts "end"
  end

  def sync_list
    emails = ENV.fetch("TEST_EMAILS").split(",")
    emails.each do |email|
      list = ChargeBee::Customer.list({"email[is]" => email})
      if (resp = list.first)
        create_user(resp.customer)
      end
    end
  end

  # TODO: refactor this to be used by WebhookHandler also
  def create_user(entry)
    customer = entry.customer
    puts customer.email
    cb_id = customer.id
    return if User.exists?(["email = ? or cb_customer_id = ?", customer.email, cb_id])

    name = [customer.first_name, customer.last_name].compact.join(" ")
    password = SecureRandom.alphanumeric(12)
    active = Util.subscription_is_annual_or_founding(entry.subscription)
    u = User.create!(
      cb_customer_id: cb_id,
      email: customer.email,
      password: password,
      password_confirmation: password,
      role: "artist",
      active: active
    )
    u.profile.name = name
    u.profile.save(validate: false)

    u.send_welcome_email if active && Rails.configuration.x.user_creation_send_email
  end
end
