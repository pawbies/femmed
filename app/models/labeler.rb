class Labeler < ApplicationRecord
  has_many :medications, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
