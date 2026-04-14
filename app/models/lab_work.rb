class LabWork < ApplicationRecord
  belongs_to :user
  has_rich_text :notes, encrypted: true
  has_many_attached :documents

  has_many :results, dependent: :destroy, class_name: "LabWork::Result"

  validates :taken_at, presence: true
end
