class Symptom < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  encrypts :name
end
