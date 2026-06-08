class Device < ApplicationRecord
  belongs_to :maker
  belongs_to :device_grade

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end