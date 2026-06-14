class Plan < ApplicationRecord
  has_many :plan_brand_plans, dependent: :destroy
  has_many :plan_brands, through: :plan_brand_plans

  CATEGORIES = ['データプラン', '音声通話プラン', 'キッズケータイプラン'].freeze

  scope :price_desc, -> { order(monthly_fee: :desc) }

  validates :name, presence: true
  validates :monthly_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :plan_brands, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
end