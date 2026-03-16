class Dose < ApplicationRecord
  belongs_to :prescription

  validates :amount_taken, presence: true, numericality: true
  validates :amount_taken,
    comparison: { greater_than: 0, less_than_or_equal_to: ->(record) { record.available_units } },
    if: -> { prescription&.pack_tracking_enabled? }
  validates :taken_at, presence: true, comparison: { less_than_or_equal_to: -> { Time.current } }

  def available_units
    return 0 unless prescription
    total_units = prescription.packs.sum(:amount)
    used_units = prescription.doses.where.not(id: id).sum(:amount_taken)
    total_units - used_units
  end
end
