class Dose < ApplicationRecord
  belongs_to :prescription

  validates :amount_taken, presence: true, numericality: true, comparison: { greater_than: 0 }
  validates :taken_at, presence: true, comparison: { less_than_or_equal_to: -> { Time.current } }
end
