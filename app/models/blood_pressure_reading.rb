class BloodPressureReading < ApplicationRecord
  belongs_to :user

  encrypts :systolic
  encrypts :diastolic
  encrypts :bpm

  validates :systolic, presence: true, numericality: { greater_than: 10, less_than: 350 }
  validates :diastolic, presence: true, numericality: { greater_than: 10, less_than: 350 }
  validates :bpm, numericality: { greater_than: 10, less_than: 300 }, allow_nil: true
end
