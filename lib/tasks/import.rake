require "csv"

namespace :import do
  desc "import chargebee users"
  task chargebee: :environment do
    File.open("tmp/cb.csv") do |file|
      CSV.foreach(file, headers: true) do |row|
        email = row["customers.email"].strip.downcase
        next if User.where(email: email).count.positive?

        password = SecureRandom.alphanumeric(12)
        cb_customer_id = row["customers.id"]

        first = row["customers.first_name"]
        last = row["customers.last_name"]
        last = "artist" if [first, last].compact.empty?
        first ||= ""

        puts email
        User.create!(email: email, first_name: first, last_name: last, password: password, password_confirmation: password, role: :artist, cb_customer_id: cb_customer_id)
      end
    end
  end

  desc "import thrivecart users"
  task thrivecart: :environment do
    temp_file = Down.download(ENV["FILE"])
    CSV.foreach(temp_file, headers: true) do |row|
      email = row["email"].strip
      next if User.where(email: email).count.positive?

      name = row["full_name"]
      password = SecureRandom.alphanumeric(12)
      puts "#{name}:\t#{email}"
      User.create!(email: email, name: name, password: password, password_confirmation: password, role: :artist)
    end
  end
end
