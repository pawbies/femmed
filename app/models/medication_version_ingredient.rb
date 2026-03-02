class MedicationVersionIngredient < ApplicationRecord
  belongs_to :medication_version
  belongs_to :active_ingredient

  validates :amount, presence: true, numericality: true

  enum :unit, {
    "mg": 0,
    "g": 1,
    "mcg": 2,
    "mL": 3,
    "L": 4,
    "IU": 5,
    "units": 6,
    "mEq": 7,
    "mmol": 8,
    "%": 14
  }, prefix: :unit, validate: true
end
