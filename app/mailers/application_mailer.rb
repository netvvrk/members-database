class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("SUPPORT_ADDRESS")
  layout "mailer"
end
