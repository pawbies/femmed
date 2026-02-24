class Prescription < ApplicationRecord
  belongs_to :user
  belongs_to :medication_version

  has_many :packs, dependent: :destroy
  has_many :doses, through: :packs

  delegate :form, to: :medication_version, allow_nil: true
  delegate :full_name, to: :medication_version, allow_nil: true

  validates :dosage, presence: true, numericality: { only_integer: true }

  def remaining_units
    total_units = packs.sum(:amount)
    used_units = doses.sum(:amount_taken)
    total_units - used_units
  end

  def remaining_doses
    ((remaining_units() * medication_version.strength_per_dose) / dosage).round(2)
  end
end
