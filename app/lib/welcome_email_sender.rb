class WelcomeEmailSender
  extend Rails.application.routes.url_helpers

  class << self
    # This is needed because we're not in a Rails class. Sending the email was in the User model before.
    def url_options
      Rails.configuration.action_mailer.default_url_options
    end

    def send(user)
      return unless Rails.application.config.x.user_creation_send_email && user.active
      delay_days = Rails.application.config.x.user_creation_email_delay
      send_email_at = if delay_days.positive?
        delay_days.days.from_now
      else
        Time.now
      end
      WelcomeEmail.create!(user: user, send_at: send_email_at)
    end

    def send_scheduled_emails
      WelcomeEmail.where("sent_at is null and send_at < ?", Time.now).each do |welcome_email|
        user = welcome_email.user

        token = user.pasword_reset_token
        # I don't know why I have to pass in the host: parameter. It should just get it from the environment.
        url = edit_user_password_url(self, reset_password_token: token, host: Rails.configuration.action_mailer.default_url_options[:host])
        mail = SendGrid::Mail.new
        mail.from = SendGrid::Email.new(email: ENV.fetch("SUPPORT_ADDRESS"))
        personalization = SendGrid::Personalization.new
        personalization.add_to(SendGrid::Email.new(email: user.email))
        personalization.add_dynamic_template_data({
          subject: "Set up your account on the Netvvrk member database",
          reset_url: url
        })
        mail.add_personalization(personalization)
        mail.template_id = "d-b9b63ed1ba0c424cba2fe52f3eb13354"

        begin
          sendgrid_send(mail)
          welcome_email.update!(sent_at: Time.now)
        rescue => e
          puts e.message
        end
      end
    end

    def sendgrid_send(mail)
      sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])
      sg.client.mail._("send").post(request_body: mail.to_json)
    end
  end
end
