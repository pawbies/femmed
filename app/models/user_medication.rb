class UserMedication < ApplicationRecord
  belongs_to :user
  belongs_to :medication_version

  has_many :packs

  validates :dosage, presence: true
end
