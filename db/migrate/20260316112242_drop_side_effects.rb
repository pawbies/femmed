class DropSideEffects < ActiveRecord::Migration[8.1]
  def change
    drop_table :diary_entry_side_effects
    drop_table :side_effects
  end
end
