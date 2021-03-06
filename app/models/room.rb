class Room < ApplicationRecord
  belongs_to :user
  has_many :photos
  has_many :reservations
  has_many :reviews

  validates :room_type, presence: true
  validates :accommodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true
  validates :listing_name, presence: true, length: {maximum: 75}
  validates :summary, presence: true, length: {maximum: 600}
  validates :address, presence: true
  validates :price, numericality: {only_integer: true, greater_than: 5}

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  
  def average_rating
    reviews.count == 0 ? 0 : reviews.average(:star).round(2)
  end
     
end
