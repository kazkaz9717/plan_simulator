class DropPlanCombinations < ActiveRecord::Migration[7.2]
  def change
    drop_table :plan_combinations
  end
end