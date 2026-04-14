class BioMarker < ApplicationRecord
  has_many :results, class_name: "LabWork::Result"

  encrypts :name, deterministic: true
  encrypts :abbreviation, deterministic: true
  encrypts :description
  encrypts :min_reference_value
  encrypts :max_reference_value

  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }
  validates :abbreviation, length: { maximum: 10 }
  validates :description, length: { maximum: 100 }
  validates :min_reference_value, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :max_reference_value, numericality: true, allow_nil: true
  validate :complete_reference_value

  enum :unit, {
    "mg/dL" => 0,
    "mmol/L" => 1,
    "g/dL" => 2,
    "g/L" => 3,
    "μmol/L" => 4,
    "mIU/L" => 5,
    "mEq/L" => 6,
    "K/μL" => 7,
    "10⁰/L" => 8,
    "IU/L" => 9
  }

  private
    def complete_reference_value
      if min_reference_value.present? && max_reference_value.nil?
        errors.add(:max_reference_value, "must be set if minimum is set")
      elsif max_reference_value.present? && min_reference_value.nil?
        errors.add(:min_reference_value, "must be set if maximum is set")
      elsif min_reference_value.present? && max_reference_value.present? && max_reference_value.to_f <= min_reference_value.to_f
        errors.add(:max_reference_value, "must be greater than minimum")
      end
    end
end
