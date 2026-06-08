class CreateDevices < ActiveRecord::Migration[7.2]
  def change
    create_table :devices do |t|
      t.references :maker, null: false, foreign_key: true
      t.references :device_grade, null: false, foreign_key: true
      t.string :name
      t.integer :price
      t.text :description

      t.timestamps
    end
  end
end
