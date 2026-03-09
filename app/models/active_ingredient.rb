class ActiveIngredient < ApplicationRecord
  has_and_belongs_to_many :medications

  has_many :medication_version_ingredients, dependent: :destroy
  has_many :medication_versions, through: :medication_version_ingredients

  scope :pk_data_complete, -> {
    where.not(half_life: nil)
      .where.not(absorption_rate: nil)
      .where.not(volume_of_distribution: nil)
  }

  validates :name, presence: true, uniqueness: true
  validates :half_life, numericality: true, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :absorption_rate, numericality: true, allow_nil: true
  validates :volume_of_distribution, numericality: true, allow_nil: true
end
