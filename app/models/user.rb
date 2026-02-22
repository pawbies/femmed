class User < ApplicationRecord
  attr_accessor :terms_of_service

  has_secure_password

  scope :admins, -> { where(role: "admin") }
  scope :users, -> { where(role: "user") }

  has_many :sessions, dependent: :destroy
  has_many :assistent_talks
  has_many :user_medications
  has_many :medication_versions, through: :user_medications

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true
  validates :terms_of_service, acceptance: true, on: :create

  enum :role, { user: 0, admin: 1 }, validate: true
  enum :pfp, {
    "medicine_kisser": 0,
    "ritalin_kisser": 1,
    "modafinil_kisser": 2,
    "kisser_kisser": 3,
    "home_kisser": 4
  }, validate: true

  def profile_picture
    "pfps/#{pfp}.png"
  end

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
