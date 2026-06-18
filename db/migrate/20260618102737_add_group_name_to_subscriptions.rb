class AddGroupNameToSubscriptions < ActiveRecord::Migration[7.2]
  def change
    add_column :subscriptions, :group_name, :string
  end
end
