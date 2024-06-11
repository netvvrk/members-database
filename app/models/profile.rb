class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  has_one_attached :cv

  validate :cv_size_and_format
  validate :avatar_size_and_format

  has_and_belongs_to_many :tags

  private

  def cv_size_and_format
    if cv.attached?
      if cv.content_type != "application/pdf"
        errors.add(:cv, "Must be a PDF")
      end
      if cv.byte_size > 25.megabytes
        errors.add(:cv, "Must be under 25MB")
      end
    end
  end

  def avatar_size_and_format
    if avatar.attached?
      if !avatar.content_type.match?(/^image\//)
        errors.add(:avatar, "Must be an image")
      end
      if avatar.byte_size > 25.megabytes
        errors.add(:avatar, "Must be under 25MB")
      end
    end
  end
end
