class Dose < ApplicationRecord
  belongs_to :pack

  validates :amount_taken, presence: true, numericality: { only_numeric: true }
  validates :taken_at, presence: true
end
