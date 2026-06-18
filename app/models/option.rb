class Option < ApplicationRecord
  scope :price_desc, -> { order(price: :desc) }

  before_save { self.group_name = nil if group_name.blank? }

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end