class DiaryEntrySideEffect < ApplicationRecord
  belongs_to :diary_entry
  belongs_to :side_effect
  accepts_nested_attributes_for :side_effect

  has_rich_text :notes, encrypted: true

  enum :severity, {
    "Barely noticeable": 0,
    "Mild": 1,
    "Moderate": 2,
    "Severe": 3,
    "Debilitating": 4
  }, validates: true
end
