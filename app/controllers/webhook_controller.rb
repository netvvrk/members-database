class WebhookController < ApplicationController
  config = Rails.application.config_for(:chargebee)
  http_basic_authenticate_with name: config["webhook_user"], password: config["webhook_password"]

  def chargebee
    render plain: "OK"
  end
end
