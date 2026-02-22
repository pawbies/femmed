class Pack < ApplicationRecord
  belongs_to :user_medication

  has_many :doses, dependent: :destroy

  validates :amount, presence: true, numericality: { only_integer: true }
end
