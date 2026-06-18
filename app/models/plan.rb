class Plan < ApplicationRecord
  has_many :plan_brand_plans, dependent: :destroy
  has_many :plan_brands, through: :plan_brand_plans

  scope :price_desc, -> { order(monthly_fee: :desc) }

  # group_nameの空文字をnilに統一（割引と同じ仕組み）
  before_save { self.group_name = nil if group_name.blank? }

  validates :name, presence: true
  validates :monthly_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :plan_brands, presence: true
end