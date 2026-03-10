class DiaryEntry < ApplicationRecord
  belongs_to :user
  has_rich_text :body

  has_many :diary_entry_side_effects, dependent: :destroy
  has_many :side_effects, through: :diary_entry_side_effects

  validates :title, presence: true
  validates :entry_for, presence: true
end
