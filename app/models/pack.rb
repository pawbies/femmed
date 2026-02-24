class Pack < ApplicationRecord
  belongs_to :prescription

  validates :amount, presence: true, numericality: { only_integer: true }, comparison: { greater_than: 0 }
  validates :aquired_at, presence: true, comparison: { less_than_or_equal_to: -> { Time.current } }
end
