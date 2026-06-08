class PlanCategory < ApplicationRecord
  has_many :plans, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end