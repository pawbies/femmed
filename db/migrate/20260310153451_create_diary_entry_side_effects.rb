class CreateDiaryEntrySideEffects < ActiveRecord::Migration[8.1]
  def change
    create_table :diary_entry_side_effects do |t|
      t.references :diary_entry, null: false, foreign_key: true
      t.references :side_effect, null: false, foreign_key: true
      t.integer :severity, null: false, default: 0

      t.timestamps
    end
  end
end
