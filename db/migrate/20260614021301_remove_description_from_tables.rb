class RemoveDescriptionFromTables < ActiveRecord::Migration[7.2]
  def change
    remove_column :plans, :description, :text
    remove_column :subscriptions, :description, :text
    remove_column :options, :description, :text
    remove_column :devices, :description, :text
    remove_column :discounts, :description, :text
  end
end