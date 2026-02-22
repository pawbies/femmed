class UserMedication < ApplicationRecord
  belongs_to :user
  belongs_to :medication_version

  has_many :packs, dependent: :destroy

  validates :dosage, presence: true
end
