class Dose < ApplicationRecord
  belongs_to :prescription

  validates :amount_taken, presence: true, numericality: { only_numeric: true }
  validates :taken_at, presence: true
end
