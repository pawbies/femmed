class ActiveIngredient < ApplicationRecord
  has_and_belongs_to_many :medications

  has_many :medication_version_ingredients, dependent: :destroy
  has_many :medication_versions, through: :medication_version_ingredients

  validates :name, presence: true, uniqueness: true
  validates :half_life, numericality: true
end
