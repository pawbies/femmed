class UserMedication < ApplicationRecord
  belongs_to :user
  belongs_to :medication_version

  validates :dosage, presence: true
end
