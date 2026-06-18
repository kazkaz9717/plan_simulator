class Device < ApplicationRecord
  belongs_to :maker

  scope :default_sorted, -> { order(release_date: :desc, price: :desc) }
  scope :by_maker, ->(maker_id) { where(maker_id: maker_id) if maker_id.present? }

  before_save { self.group_name = nil if group_name.blank? }

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end