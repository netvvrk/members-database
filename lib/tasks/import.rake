require "CSV"

namespace :import do
  desc "import chargebee users"
  task chargebee: :environment do
    temp_file = Down.download(ENV["FILE"])
    File.open(temp_file) do |file|
      CSV.foreach(file, headers: true) do |row|
        email = row["customers.email"].strip
        next if User.where(email: email).count.positive?

        first = row["customers.first_name"]
        last = row["customers.last_name"]
        name = [first, last].compact.join(" ")
        name = "Artist" if name.blank?
        password = SecureRandom.alphanumeric(12)
        puts "#{name}:\t#{email}"
        User.create!(email: email, name: name, password: password, password_confirmation: password, role: :artist)
      end
    end
  end
end