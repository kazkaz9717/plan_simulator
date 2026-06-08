class CreateOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :options do |t|
      t.string :name
      t.integer :price
      t.text :description

      t.timestamps
    end
  end
end
