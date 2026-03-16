class DropDiaryEntries < ActiveRecord::Migration[8.1]
  def change
    drop_table :diary_entries
  end
end
