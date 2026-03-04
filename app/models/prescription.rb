class Prescription < ApplicationRecord
  belongs_to :user
  belongs_to :medication_version

  has_one :medication, through: :medication_version

  has_many :packs, dependent: :destroy
  has_many :doses, dependent: :destroy
  has_many :medication_version_ingredients, through: :medication_version

  delegate :form, to: :medication_version, allow_nil: true
  delegate :full_name, to: :medication_version, allow_nil: true

  validates :amount, presence: true, numericality: true
  validates :active, inclusion: { in: [ true, false ] }

  def remaining_units
    total_units = packs.sum(:amount)
    used_units = doses.sum(:amount_taken)
    total_units - used_units
  end

  def remaining_doses
    (remaining_units() / amount).round(2)
  end
end
