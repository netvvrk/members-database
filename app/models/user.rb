class User < ApplicationRecord
  devise :database_authenticatable, :lockable,
    :recoverable, :rememberable, :trackable, :validatable

  enum :role, [:artist, :curator, :admin]

  def show_artworks?
    artist? || admin?
  end

  def show_browse?
    curator? || admin?
  end

  def show_users?
    admin?
  end
end
