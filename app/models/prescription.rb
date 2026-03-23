class Prescription < ApplicationRecord
  belongs_to :user
  belongs_to :medication_version

  has_one :medication, through: :medication_version

  has_many :packs, dependent: :destroy, class_name: "Prescription::Pack"
  has_many :doses, dependent: :destroy, class_name: "Prescription::Dose"

  has_many :recent_doses, -> { where(taken_at: 1.week.ago..) }, class_name: "Prescription::Dose"
  has_many :medication_version_ingredients, through: :medication_version

  delegate :form, to: :medication_version, allow_nil: true
  delegate :full_name, to: :medication_version, allow_nil: true

  validates :amount, presence: true, numericality: true, comparison: { greater_than: 0 }
  validates :active, inclusion: { in: [ true, false ] }
  validates :pack_tracking_enabled, inclusion: { in: [ true, false ] }
  validates :preview_past, presence: true, numericality: true, comparison: { greater_than_or_equal_to: 0 }
  validates :preview_future, presence: true, numericality: true, comparison: { greater_than_or_equal_to: 0 }

  serialize :routine, coder: IceCube::Schedule

  def remaining_units
    total_units = packs.sum(:amount)
    used_units = doses.sum(:amount_taken)
    total_units - used_units
  end

  def remaining_doses
    (remaining_units() / amount).round(2)
  end
end
