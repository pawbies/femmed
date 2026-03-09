class MedicationVersionIngredient < ApplicationRecord
  belongs_to :medication_version
  belongs_to :active_ingredient

  scope :pk_compatible, -> {
    joins(:active_ingredient)
      .merge(ActiveIngredient.pk_data_complete)
      .where(unit: %w[mg mcg g])
  }
  scope :pk_incompatible, -> { where.not(id: pk_compatible) }


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

  def available_for_pk?
    active_ingredient.half_life.present? && active_ingredient.absorption_rate.present? && active_ingredient.volume_of_distribution.present? && (%w[ mg mcg g ]).include?(unit)
  end

  def pk_multiplier
    case unit
    when "mg"  then 1.0
    when "g"   then 0.001
    when "mcg" then 1000.0
    else nil
    end
  end
end
