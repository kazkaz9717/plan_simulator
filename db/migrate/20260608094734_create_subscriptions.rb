class CreateSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.integer :monthly_fee
      t.text :description

      t.timestamps
    end
  end
end
