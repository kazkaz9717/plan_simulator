class AddCategoryToPlans < ActiveRecord::Migration[7.2]
  def change
    add_column :plans, :category, :string
  end
end
