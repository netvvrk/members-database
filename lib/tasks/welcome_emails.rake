namespace :welcome_emails do
  desc "Send welcome emails that are due"
  task send: :environment do
    unless Rails.configuration.x.user_creation_send_email
      puts "user_creation_send_email is not set -- exiting"
      exit
    end
  end
end
