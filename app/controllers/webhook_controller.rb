class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def chargebee
    render plain: "OK"
  end
end
