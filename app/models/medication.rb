class Medication < ApplicationRecord
  belongs_to :labeler, optional: true
  belongs_to :form
  has_rich_text :notes

  has_many :medication_versions

  validates :name, presence: true
end
