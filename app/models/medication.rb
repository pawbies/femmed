class Medication < ApplicationRecord
  has_one_attached :image

  belongs_to :labeler, optional: true
  belongs_to :form
  has_rich_text :notes

  has_many :versions, class_name: "MedicationVersion", foreign_key: "medication_id"

  has_and_belongs_to_many :active_ingredients
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :references

  validates :name, presence: true
end
