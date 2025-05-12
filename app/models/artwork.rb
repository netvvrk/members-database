class Artwork < ApplicationRecord
  include PgSearch::Model

  MAX_ARTWORK_IMAGES = 3

  MEDIUM_LIST = ["Painting", "Photography", "Sculpture", "Prints", "Work on Paper", "NFT",
    "Design", "Drawing", "Installation", "Film/Video", "Jewelry", "Performance Art",
    "Reproduction", "Ephemera or Merchandise", "Digital Art", "Textile"]

  validates :title, :medium, :year, presence: true
  validates :location, presence: true, unless: -> { ["Digital Art", "NFT"].include?(medium) }
  validates :units, inclusion: {in: %w[in cm],
                                message: "%{value} is not a valid unit"}
  validates :duration, numericality: {greater_than_or_equal_to: 0, allow_blank: true}
  validates :price, numericality: {greater_than_or_equal_to: 0, allow_blank: true}
  validates :year, numericality: {greater_than_or_equal_to: 1900}
  validates :medium, inclusion: {in: MEDIUM_LIST}

  belongs_to :user
  positioned on: :user

  has_one :profile, through: :user
  has_many :images, -> { order("position") }, dependent: :destroy

  pg_search_scope :search, against: [:title, :medium, :description], associated_against: {profile: :name}

  scope :is_visible, -> { where("visible = true") }
  scope :is_active, -> { where("active = true") }

  scope :with_images, -> {
                        joins(:images).distinct(:artwork_id)
                      }
  
  scope :has_max_price, -> (price) {  where("price < ? ", price) }
  scope :has_min_price, -> (price) {  where("price > ? ", price) }
  scope :has_medium, -> (medium) { where("medium in (?) ", medium) }
  scope :has_location, -> (location) { where("location in (?) ", location) }

  def artist_name
    user.profile.name
  end

  def more_images_allowed?
    images.count < MAX_ARTWORK_IMAGES
  end
end
