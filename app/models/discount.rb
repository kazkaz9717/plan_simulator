class Discount < ApplicationRecord
  has_many :discount_plan_brands, dependent: :destroy
  has_many :plan_brands, through: :discount_plan_brands

  before_save { self.group_name = nil if group_name.blank? }

  validates :name, presence: true, uniqueness: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :duration_months, numericality: { greater_than: 0 }, allow_nil: true
  validates :plan_brands, presence: true
end