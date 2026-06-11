class DiscountPlanBrand < ApplicationRecord
  belongs_to :discount
  belongs_to :plan_brand
end