class Subscription < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :monthly_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
end