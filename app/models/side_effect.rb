class SideEffect < ApplicationRecord
  belongs_to :user

  has_many :diary_entry_side_effects
  has_many :diary_entries, through: :diary_entry_side_effects

  validates :name, presence: true
end
