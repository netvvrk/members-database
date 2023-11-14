require "faker"

desc "Add fake users and artworks to the database"
task fake_data: :environment do
  20.times do
    email = "#{Faker::Alphanumeric.alphanumeric(number: 10)}@#{Faker::Alphanumeric.alphanumeric(number: 10)}.com"
    password = Faker::Alphanumeric.alphanumeric(number: 20)
    user = User.create!(email: email, name: Faker::Name.name, password: password, password_confirmation: password)

    10.times do
      attr = {
        title: Faker::Lorem.words(number: 4),
        medium: Faker::Construction.material,
        description: Faker::Lorem.paragraph,
        location: Faker::Address.city,
        year: Faker::Number.between(from: 2000, to: 2023)
      }
      if Faker::Boolean.boolean
        attr[:duration] = Faker::Number.between(from: 5, to: 120)
      else
        attr[:height] = Faker::Number.between(from: 12, to: 36)
        attr[:width] = Faker::Number.between(from: 12, to: 36)
        attr[:depth] = Faker::Number.between(from: 2, to: 10) if Faker::Boolean.boolean
      end
      artwork = user.artworks.create!(attr)

      3.times do
        temp_file = Down.download("https://loremflickr.com/1000/800")
        image = artwork.images.new(caption: Faker::Lorem.words(number: 1))
        image.file.attach(io: temp_file, content_type: "image/jpg", filename: "#{Faker::Lorem.words(number: 1)}.jpg")
        image.save!
      end
      print "."
    end
  end
  puts ""
end
