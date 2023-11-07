class Image < ApplicationRecord
  belongs_to :artwork
  has_one_attached :file

  validates :file, presence: true
end
