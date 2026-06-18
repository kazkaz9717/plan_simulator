class AddGroupNameToDevices < ActiveRecord::Migration[7.2]
  def change
    add_column :devices, :group_name, :string
  end
end
