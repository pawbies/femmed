class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_medications
  has_many :medications, through: :user_medications

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
