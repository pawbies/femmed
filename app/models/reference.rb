class Reference < ApplicationRecord
  has_and_belongs_to_many :medications

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true
end
