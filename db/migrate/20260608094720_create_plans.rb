class CreatePlans < ActiveRecord::Migration[7.2]
  def change
    create_table :plans do |t|
      t.references :plan_category, null: false, foreign_key: true
      t.string :name
      t.integer :monthly_fee
      t.text :description

      t.timestamps
    end
  end
end
