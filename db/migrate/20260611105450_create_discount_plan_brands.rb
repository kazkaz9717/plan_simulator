class CreateDiscountPlanBrands < ActiveRecord::Migration[7.2]
  def change
    create_table :discount_plan_brands do |t|
      t.references :discount, null: false, foreign_key: true
      t.references :plan_brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
