class User < ApplicationRecord
  devise :database_authenticatable, :lockable,
    :recoverable, :rememberable, :trackable, :validatable

  enum :role, [:artist, :curator, :admin]

  validates :email, :name, :role, presence: true

  has_many :artworks

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
