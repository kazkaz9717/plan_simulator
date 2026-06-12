class AddGroupNameToDiscounts < ActiveRecord::Migration[7.2]
  def change
    add_column :discounts, :group_name, :string
  end
end
