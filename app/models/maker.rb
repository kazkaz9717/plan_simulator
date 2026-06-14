class Maker < ApplicationRecord
  has_many :devices, -> { order(release_date: :desc, price: :desc) }, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end