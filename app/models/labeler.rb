class Labeler < ApplicationRecord
  has_many :medications

  validates :name, presence: true, uniqueness: true
end
