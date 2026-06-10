class CreatePlanBrandPlans < ActiveRecord::Migration[7.2]
  def change
    create_table :plan_brand_plans do |t|
      t.references :plan, null: false, foreign_key: true
      t.references :plan_brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
