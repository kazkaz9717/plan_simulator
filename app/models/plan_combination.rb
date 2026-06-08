class PlanCombination < ApplicationRecord
  belongs_to :data_plan
  belongs_to :voice_plan
end
