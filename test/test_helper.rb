ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/autorun"
require "mocha/minitest"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include Devise::Test::IntegrationHelpers

    def create_artwork(user, medium = false)
      r = Random.new

      user.artworks.create!(title: "Title#{r.rand(100)}", medium: medium || Artwork::MEDIUM_LIST[r.rand(Artwork::MEDIUM_LIST.size)],
        material: "material#{r.rand(100)}", visible: true, height: 2, width: 3, location: "Brooklyn", year: 2025)
    end

    def with_config(key, value)
      old = Rails.application.config.x.public_send(key)
      Rails.application.config.x.public_send(:"#{key}=", value)
      yield
    ensure
      Rails.application.config.x.public_send(:"#{key}=", old)
    end
  end
end
