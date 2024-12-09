class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  has_one_attached :cv

  validates :bio, :avatar, presence: true, on: :update
  validates :bio, length: {maximum: 2500}, on: :update

  validate :cv_size_and_format
  validate :avatar_size_and_format
  validate :name, on: :update

  has_and_belongs_to_many :tags

  MAX_AVATAR_SIZE = 25
  MAX_CV_SIZE = 25

  private

  def cv_size_and_format
    if cv.attached?
      if cv.content_type != "application/pdf"
        errors.add(:cv, "Must be a PDF")
      end
      if cv.byte_size > MAX_CV_SIZE.megabytes
        errors.add(:cv, "Must be under #{MAX_CV_SIZE}MB")
      end
    end
  end

  def avatar_size_and_format
    if avatar.attached?
      if !avatar.content_type.match?(/^image\//)
        errors.add(:avatar, "Must be an image")
      end
      if avatar.byte_size > MAX_AVATAR_SIZE.megabytes
        errors.add(:avatar, "Must be under #{MAX_AVATAR_SIZE}MB")
      end
    end
  end
end
