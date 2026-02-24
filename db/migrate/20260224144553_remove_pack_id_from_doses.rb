class RemovePackIdFromDoses < ActiveRecord::Migration[8.1]
  def change
    remove_reference :doses, :pack, null: false, foreign_key: true
  end
end
