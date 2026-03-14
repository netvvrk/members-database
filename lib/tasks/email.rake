namespace :email do
  desc "Send welcome emails to users whose delay period has passed"
  task send_delayed_welcome_emails: :environment do
    WelcomeEmailSender.send_delayed_emails
  end
end
