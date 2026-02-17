class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_medications
  has_many :medication_versions, through: :user_medications

  validates :email_address, presence: true, uniqueness: true
  validates :username, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
