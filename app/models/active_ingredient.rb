class ActiveIngredient < ApplicationRecord
  has_and_belongs_to_many :medications

  validates :name, presence: true, uniqueness: true
end
