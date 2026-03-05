class MedicationReleaseProfile < ApplicationRecord
  belongs_to :medication
  belongs_to :release_profile

  validates :delay, presence: true, if: -> { release_profile&.name == "Bimodal" }
  validates :release_duration, presence: true, if: -> { release_profile&.name == "Extended" }

  validates :delay, numericality: true, comparison: { greater_than: 0 }, allow_nil: true
  validates :release_duration, numericality: true, comparison: { greater_than: 0 }, allow_nil: true
end
