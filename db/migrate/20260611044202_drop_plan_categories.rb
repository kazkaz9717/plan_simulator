class DropPlanCategories < ActiveRecord::Migration[7.2]
  def change
    remove_column :plans, :plan_category_id, :integer
    drop_table :plan_categories
  end
end