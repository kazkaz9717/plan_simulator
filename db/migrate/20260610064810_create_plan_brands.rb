class CreatePlanBrands < ActiveRecord::Migration[7.2]
  def change
    create_table :plan_brands do |t|
      t.string :name

      t.timestamps
    end
  end
end
