class User < ApplicationRecord
  include PgSearch::Model
  include Rails.application.routes.url_helpers
  include SendGrid

  devise :database_authenticatable, :lockable,
    :recoverable, :rememberable, :trackable, :validatable

  enum :role, [:artist, :curator, :admin] # curator is deprecated

  ARTIST = 0
  CURATOR = 1 # DEPRECATED
  ADMIN = 2

  validates :email, :role, presence: true

  has_many :artworks, -> { order('position') }, dependent: :destroy

  has_one :profile

  scope :is_active, -> { where(active: true) }

  pg_search_scope :search, against: [:email], associated_against: {profile: :name}

  after_create -> { Profile.create!(user_id: id) }
  after_save :update_artworks

  def show_artworks?
    artist? || admin?
  end

  def show_users?
    admin?
  end

  def has_profile?
    return false unless profile

    artist? || admin?
  end

  def active_for_authentication?
    super && active?
  end

  def more_artworks_allowed?
    artworks.count < 10
  end

  def update_artworks
    Artwork.where(user: self).update_all(active: active)
  end

  # https://members-staging.vvrkshop.art/users/password/edit?reset_password_token=ysyb3fR86CZsR4-ECmmC

  def send_welcome_email
    token = set_reset_password_token
    # I don't know why I have to pass in the host: parameter. It should just get it from the environment.
    url = edit_user_password_url(self, reset_password_token: token, host: Rails.configuration.action_mailer.default_url_options[:host])
    mail = Mail.new
    mail.from = Email.new(email: ENV.fetch("SUPPORT_ADDRESS"))
    personalization = Personalization.new
    personalization.add_to(Email.new(email: email))
    personalization.add_dynamic_template_data({
      subject: "Set up your account on the Netvvrk member database",
      reset_url: url
    })
    mail.add_personalization(personalization)
    mail.template_id = "d-b9b63ed1ba0c424cba2fe52f3eb13354"

    sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])
    begin
      sg.client.mail._("send").post(request_body: mail.to_json)
      update!(welcome_email_sent_at: Time.now)
    rescue => e
      puts e.message
    end
  end
end
