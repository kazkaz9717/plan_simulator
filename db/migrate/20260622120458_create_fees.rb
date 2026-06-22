class CreateFees < ActiveRecord::Migration[7.2]
  def change
    create_table :fees do |t|
      t.string :name
      t.integer :price
      t.string :group_name
      t.integer :payment_timing, default: 0, null: false

      t.timestamps
    end
  end
end