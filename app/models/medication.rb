class Medication < ApplicationRecord
  belongs_to :labeler, optional: true
  belongs_to :form
  has_rich_text :notes

  has_many :medication_versions

  has_and_belongs_to_many :active_ingredients

  validates :name, presence: true
end
