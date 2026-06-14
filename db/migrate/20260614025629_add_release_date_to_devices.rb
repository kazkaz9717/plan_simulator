class AddReleaseDateToDevices < ActiveRecord::Migration[7.2]
  def change
    add_column :devices, :release_date, :date
  end
end
