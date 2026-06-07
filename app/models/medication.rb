class Medication < ApplicationRecord
  has_one_attached :image
  has_rich_text :notes

  belongs_to :labeler, optional: true
  belongs_to :form

  has_many :versions, class_name: "MedicationVersion", foreign_key: "medication_id", dependent: :destroy
  has_many :prescriptions, through: :versions

  has_and_belongs_to_many :active_ingredients
  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :form, presence: true

  validates :release_type, presence: true
  validates :delay, presence: true, if: :bimodal?
  validates :release_duration, presence: true, if: :extended?

  validates :delay, numericality: { greater_than: 0 }, allow_nil: true
  validates :release_duration, numericality: { greater_than: 0 }, allow_nil: true

  enum :release_type, {
    immediate: 0,
    bimodal: 1,
    extended: 2
  }, validate: true
end
