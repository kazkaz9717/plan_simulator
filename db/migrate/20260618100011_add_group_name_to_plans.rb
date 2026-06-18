class AddGroupNameToPlans < ActiveRecord::Migration[7.2]
  def change
    add_column :plans, :group_name, :string
  end
end
