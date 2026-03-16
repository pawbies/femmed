class RenameAquiredAtToAcquiredAtOnPacks < ActiveRecord::Migration[8.0]
  def change
    rename_column :packs, :aquired_at, :acquired_at
  end
end
