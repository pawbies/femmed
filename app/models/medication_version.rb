class MedicationVersion < ApplicationRecord
  belongs_to :medication, inverse_of: :versions

  has_many :prescriptions, dependent: :destroy
  has_many :medication_version_ingredients, dependent: :destroy
  has_many :active_ingredients, through: :medication_version_ingredients
  has_many :pk_compatible_ingredients, -> { pk_compatible }, class_name: "MedicationVersionIngredient"

  accepts_nested_attributes_for :medication_version_ingredients

  delegate :form, to: :medication, allow_nil: true

  validates :added_name, presence: true

  def full_name
    "#{medication.name} #{added_name}"
  end

  def available_for_pk?
    pk_compatible_ingredients.none?
  end
end
