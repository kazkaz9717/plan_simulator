class Plan < ApplicationRecord
  belongs_to :plan_category

  has_many :data_plan_combinations,
           class_name: 'PlanCombination',
           foreign_key: 'data_plan_id',
           dependent: :destroy
  has_many :voice_plan_combinations,
           class_name: 'PlanCombination',
           foreign_key: 'voice_plan_id',
           dependent: :destroy

  validates :name, presence: true
  validates :monthly_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
end