class PlanBrand < ApplicationRecord
  has_many :plan_brand_plans, dependent: :destroy
  has_many :plans, through: :plan_brand_plans

  validates :name, presence: true, uniqueness: true
end