class RenamePacksToPrescriptionPacks < ActiveRecord::Migration[8.1]
  def change
    rename_table :packs, :prescription_packs
  end
end
