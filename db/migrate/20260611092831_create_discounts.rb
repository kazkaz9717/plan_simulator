class CreateDiscounts < ActiveRecord::Migration[7.2]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :amount
      t.integer :duration_months
      t.text :description

      t.timestamps
    end
  end
end
