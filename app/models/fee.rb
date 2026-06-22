class Fee < ApplicationRecord
  # 金額の高い順
  scope :price_desc, -> { order(price: :desc) }

  # group_nameの空文字をnilに統一（他マスタと同じ）
  before_save { self.group_name = nil if group_name.blank? }

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end