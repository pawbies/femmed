class DiaryEntrySideEffect < ApplicationRecord
  belongs_to :diary_entry
  belongs_to :side_effect
  has_rich_text :notes
end
