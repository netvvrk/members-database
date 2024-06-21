class WebhookController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  config = Rails.configuration.x.chargebee
  http_basic_authenticate_with name: config.webhook_user, password: config.webhook_pass

  def chargebee
    event = ChargeBee::Event.deserialize(request.body.read)
    WebhookHandler.handle_payload(event)
    render plain: "OK"
  end
end
