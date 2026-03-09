class Medication < ApplicationRecord
  has_one_attached :image
  has_rich_text :notes

  belongs_to :labeler, optional: true
  belongs_to :form

  has_many :versions, class_name: "MedicationVersion", foreign_key: "medication_id", dependent: :destroy
  has_many :prescriptions, through: :versions

  has_one :medication_release_profile, dependent: :destroy
  has_one :release_profile, through: :medication_release_profile
  accepts_nested_attributes_for :medication_release_profile

  has_and_belongs_to_many :active_ingredients
  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :medication_release_profile, presence: true
  validates :form, presence: true
end
