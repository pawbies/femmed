class Labeler < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
