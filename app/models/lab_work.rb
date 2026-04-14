class LabWork < ApplicationRecord
  belongs_to :user
  has_rich_text :notes, encrypted: true
  has_many_attached :documents

  validates :taken_at, presence: true
end
