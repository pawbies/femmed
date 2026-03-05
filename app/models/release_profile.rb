class ReleaseProfile < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :medication_release_profiles
  has_many :medications, through: :medication_release_profiles
end
