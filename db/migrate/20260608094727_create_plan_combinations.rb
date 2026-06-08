class CreatePlanCombinations < ActiveRecord::Migration[7.2]
  def change
    create_table :plan_combinations do |t|
      t.references :data_plan, null: false, foreign_key: { to_table: :plans }
      t.references :voice_plan, null: false, foreign_key: { to_table: :plans }

      t.timestamps
    end
  end
end