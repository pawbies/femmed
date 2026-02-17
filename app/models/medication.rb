class Medication < ApplicationRecord
  belongs_to :labeler, optional: true
  belongs_to :form
  has_rich_text :notes

  validates :name, presence: true
end
