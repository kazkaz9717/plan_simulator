class RemovePlanBrandIdFromPlans < ActiveRecord::Migration[7.2]
  def change
    remove_column :plans, :plan_brand_id, :integer
  end
end