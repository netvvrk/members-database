class Artwork < ApplicationRecord
  include PgSearch::Model

  validates :title, :medium, :location, :year, presence: true
  validates :units, inclusion: {in: %w[in cm],
                                message: "%{value} is not a valid unit"}
  validates :duration, numericality: {greater_than_or_equal_to: 0, allow_blank: true}
  validates :price, numericality: {greater_than_or_equal_to: 0, allow_blank: true}
  validates :year, numericality: {greater_than_or_equal_to: 1900}

  belongs_to :user
  has_many :images, dependent: :destroy

  pg_search_scope :search, against: [:title, :medium, :description], associated_against: {user: [:first_name, :last_name]}

  scope :is_visible, -> { where("visible = true") }
  scope :is_active, -> { where("active = true") }

  scope :with_images, -> {
                        joins(:images).distinct(:artwork_id)
                      }

  MAX_ARTWORK_IMAGES = 3

  def artist_name
    user.profile.name
  end

  def more_images_allowed?
    images.count < MAX_ARTWORK_IMAGES
  end
end
