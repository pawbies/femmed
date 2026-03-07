class CreateDiaryEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :diary_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.datetime :entry_for, null: false

      t.timestamps
    end
  end
end
