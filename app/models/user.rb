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

  has_many :artworks, -> { order("position") }, dependent: :destroy

  has_one :profile

  scope :is_active, -> { where(active: true) }

  pg_search_scope :search, against: [:email], associated_against: {profile: :name}

  before_create :set_send_welcome_email_at
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

  def pasword_reset_token
    set_reset_password_token
  end

  def set_send_welcome_email_at
    self.send_welcome_email_at = 1.hour.from_now
  end
end
