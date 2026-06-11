class PlanBrand < ApplicationRecord
  has_many :plan_brand_plans, dependent: :destroy
  has_many :plans, through: :plan_brand_plans
  has_many :discount_plan_brands, dependent: :destroy
  has_many :discounts, through: :discount_plan_brands

  validates :name, presence: true, uniqueness: true
end