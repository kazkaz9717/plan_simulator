class AddGroupNameToOptions < ActiveRecord::Migration[7.2]
  def change
    add_column :options, :group_name, :string
  end
end
