class AddPlanBrandIdToPlans < ActiveRecord::Migration[7.2]
  def change
    add_reference :plans, :plan_brand, null: true, foreign_key: true
  end
end