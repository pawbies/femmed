class ActiveIngredient < ApplicationRecord
  has_and_belongs_to_many :medications

  has_many :medication_version_ingredients, dependent: :destroy
  has_many :medication_versions, through: :medication_version_ingredients

  validates :name, presence: true, uniqueness: true
  validates :half_life, numericality: true, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true

  def amount_in_system(user)
    return 0.0 if half_life.nil? || half_life <= 0

    now = Time.current

    Dose
      .joins(prescription: { medication_version: :medication_version_ingredients })
      .where(
        prescriptions: { user_id: user.id },
        medication_version_ingredients: { active_ingredient_id: id }
      )
      .includes(prescription: { medication_version: :medication_version_ingredients })
      .sum do |dose|
        mvi = dose.prescription
                  .medication_version
                  .medication_version_ingredients
                  .find { |i| i.active_ingredient_id == id }

        next 0.0 unless mvi&.amount

        elapsed_hours = (now - dose.taken_at) / 1.hour
        dose.amount_taken * mvi.amount * (0.5 ** (elapsed_hours / half_life))
      end
  end
end
