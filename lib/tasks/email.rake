namespace :email do
  desc "Send welcome emails to users whose delay period has passed"
  task send_scheduled_welcome_emails: :environment do
    WelcomeEmailSender.send_scheduled_emails
  end
end
