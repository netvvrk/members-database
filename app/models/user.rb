class User < ApplicationRecord
  include PgSearch::Model

  devise :database_authenticatable, :lockable,
    :recoverable, :rememberable, :trackable, :validatable

  enum :role, [:artist, :curator, :admin]

  ARTIST = 0
  CURATOR = 1
  ADMIN = 2

  validates :email, :role, presence: true
  validates :last_name, presence: true, on: :update

  has_many :artworks, dependent: :destroy

  has_one :profile

  scope :is_active, -> { where(active: true) }

  pg_search_scope :search, against: [:first_name, :last_name, :email]

  after_create -> { Profile.create!(user_id: id) }
  after_save :update_artworks

  def name
    [first_name, last_name].compact.join(" ")
  end

  def show_artworks?
    artist? || admin?
  end

  def show_users?
    admin?
  end

  def has_profile?
    artist?
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
end
