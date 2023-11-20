class Artwork < ApplicationRecord
  validates :title, :medium, :location, :year, presence: true
  validates :units, inclusion: {in: %w[in cm],
                                message: "%{value} is not a valid unit"}

  validate :dimensions

  belongs_to :user
  has_many :images, dependent: :destroy

  def more_images_allowed?
    images.count < 3
  end

  private

  def dimensions
    if duration.blank? && (height.blank? || width.blank?)
      errors.add(:either, "Height and Width or Duration is required")
    end
  end
end
