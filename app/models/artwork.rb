class Artwork < ApplicationRecord
  validates :title, :medium, :location, :year, presence: true
  validates :units, inclusion: {in: %w[in cm],
                                message: "%{value} is not a valid unit"}

  validate :dimensions

  belongs_to :user

  private

  def dimensions
    if duration.blank? && (height.blank? || width.blank?)
      errors.add(:either, "Height and Width or Duration is required")
    end
  end
end
