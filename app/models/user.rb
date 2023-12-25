class User < ApplicationRecord
  devise :database_authenticatable, :lockable,
    :recoverable, :rememberable, :trackable, :validatable

  enum :role, [:artist, :curator, :admin]

  ARTIST = 0
  CURATOR = 1
  ADMIN = 2

  validates :email, :last_name, :role, presence: true

  has_many :artworks, dependent: :destroy

  scope :is_active, -> { where(active: true) }

  def name
    [first_name, last_name].compact.join(" ")
  end

  def show_artworks?
    artist? || admin?
  end

  def show_browse?
    curator? || admin?
  end

  def show_users?
    admin?
  end

  def active_for_authentication?
    super && active?
  end

  def more_artworks_allowed?
    artworks.count < 10
  end
end
