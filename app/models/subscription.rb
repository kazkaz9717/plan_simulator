class Subscription < ApplicationRecord
  scope :price_desc, -> { order(monthly_fee: :desc) }

  before_save { self.group_name = nil if group_name.blank? }

  validates :name, presence: true, uniqueness: true
  validates :monthly_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
end