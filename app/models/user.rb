class User < ApplicationRecord
  has_secure_password

  enum role: { general: 0, admin: 1 }

  validates :name, presence: true, uniqueness: true
  validates :role, presence: true
end