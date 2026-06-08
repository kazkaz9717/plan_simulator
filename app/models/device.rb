class Device < ApplicationRecord
  belongs_to :maker
  belongs_to :device_grade
end
