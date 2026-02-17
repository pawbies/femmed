class MedicationVersion < ApplicationRecord
  belongs_to :medication

  has_many :user_medications

  validates :added_name, presence: true
  validates :strength_per_dose, presence: true
  validates :ndc, presence: true
end
