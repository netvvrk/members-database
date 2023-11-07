ImageKitIo.configure do |config|
  if Rails.env.development?
    config.public_key = ENV.fetch("IMAGEKIT_PUBLIC_KEY")
    config.private_key = ENV.fetch("IMAGEKIT_PRIVATE_KEY")
    config.url_endpoint = ENV.fetch("IMAGEKIT_URL")
  end
  config.service = :active_storage
  # config.constants.MISSING_PRIVATE_KEY = 'custom error message'
end
