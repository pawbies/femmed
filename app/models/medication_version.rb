class MedicationVersion < ApplicationRecord
  belongs_to :medication

  has_many :prescriptions

  delegate :form, to: :medication, allow_nil: true

  validates :added_name, presence: true
  validates :strength_per_dose, presence: true
  validates :ndc, presence: true
  validates :unit, presence: true

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
    "tablet": 9,
    "capsule": 10,
    "drop": 11,
    "puff": 12,
    "patch": 13,
    "%": 14
  }, prefix: :unit, validate: true

  def full_name
    "#{medication.name} #{added_name}"
  end
end
