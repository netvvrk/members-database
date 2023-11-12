class Image < ApplicationRecord
  belongs_to :artwork
  has_one_attached :file

  validates :file, presence: true
  # validate :valid_image

  before_destroy :purge_file

  def is_video?
    file.blob.content_type.include?("video")
  end

  private

  def valid_image
    return unless file.attached?
    unless file.blob.byte_size <= 10.megabyte
      errors.add(:file, "is too large")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(file.content_type)
      errors.add(:file, "must be a JPEG or PNG")
    end
  end

  def purge_file
    file.purge
  end
end
