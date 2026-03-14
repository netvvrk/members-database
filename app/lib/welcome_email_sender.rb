class WelcomeEmailSender
  extend Rails.application.routes.url_helpers

  class << self
    # This is needed because we're not in a Rails class. Sending the email was in the User model before.
    def url_options
      Rails.configuration.action_mailer.default_url_options
    end

    def send(user)
      return unless Rails.application.config.x.user_creation_send_email && user.active && user.welcome_email_sent_at.nil?

      delay_days = Rails.application.config.x.user_creation_email_delay

      # delay sending email
      if delay_days.positive? && user.send_welcome_email_at.nil?
        user.update!(send_welcome_email_at: delay_days.days.from_now)
        return
      end

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
        user.update!(welcome_email_sent_at: Time.now)
      rescue => e
        puts e.message
      end
    end

    def send_delayed_emails
      User.where("send_welcome_email_at <= ? AND welcome_email_sent_at IS NULL AND active = TRUE", Time.now).each do |user|
        send(user)
      end
    end

    def sendgrid_send(mail)
      sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])
      sg.client.mail._("send").post(request_body: mail.to_json)
    end
  end
end
