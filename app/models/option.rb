class Option < ApplicationRecord
  scope :price_desc, -> { order(price: :desc) }

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end