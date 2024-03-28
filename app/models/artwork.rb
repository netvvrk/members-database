class Artwork < ApplicationRecord
  include PgSearch::Model

  validates :title, :medium, :location, :year, presence: true
  validates :units, inclusion: {in: %w[in cm],
                                message: "%{value} is not a valid unit"}

  validate :dimensions

  belongs_to :user
  has_many :images, dependent: :destroy

  pg_search_scope :search, against: [:title, :medium, :description], associated_against: {user: [:first_name, :last_name]}

  scope :is_visible, -> { where("visible = true") }

  scope :with_images, -> {
                        joins(:images).distinct(:artwork_id)
                      }

  MAX_ARTWORK_IMAGES = 3

  def more_images_allowed?
    images.count < MAX_ARTWORK_IMAGES
  end

  private

  def dimensions
    if duration.blank? && (height.blank? || width.blank?)
      errors.add(:either, "Height and Width or Duration is required")
    end
  end

  def artist_name
    user.name
  end
end
