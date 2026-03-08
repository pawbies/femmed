class DiaryEntry < ApplicationRecord
  belongs_to :user
  has_rich_text :body

  validates :title, presence: true
  validates :entry_for, presence: true
end
