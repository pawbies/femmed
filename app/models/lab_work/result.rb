class LabWork::Result < ApplicationRecord
  belongs_to :lab_work
  belongs_to :bio_marker

  encrypts :value

  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
