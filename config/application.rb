require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MembersDatabase
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.view_specs false
    end

    config.action_mailer.default_url_options = {host: "localhost", port: 3000}
    config.active_storage.service = :imagekitio

    # use sendgrid
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: ENV.fetch("SMTP_HOST"),
      port: 587,
      domain: ENV.fetch("DOMAIN"),
      user_name: ENV.fetch("SMTP_USER"),
      password: ENV.fetch("SMTP_PASSWORD"),
      aauthentication: "plain",
      enable_starttls: true
    }

    # whether to send password reset email when a new user is created through sync or webhook
    config.send_password_reset = ENV.fetch("SEND_PASSWORD_RESET", false)
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end
end
