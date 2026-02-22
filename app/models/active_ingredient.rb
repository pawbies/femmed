class ActiveIngredient < ApplicationRecord
  has_and_belongs_to_many :medications

  validates :name, presence: true, uniqueness: true
  # validate half_life in the future
end
