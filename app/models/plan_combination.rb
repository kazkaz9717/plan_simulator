class PlanCombination < ApplicationRecord
  belongs_to :data_plan, class_name: 'Plan'
  belongs_to :voice_plan, class_name: 'Plan'

  validates :data_plan_id, uniqueness: { scope: :voice_plan_id }
end