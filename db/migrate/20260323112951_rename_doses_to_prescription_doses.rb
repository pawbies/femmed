class RenameDosesToPrescriptionDoses < ActiveRecord::Migration[8.1]
  def change
    rename_table :doses, :prescription_doses
  end
end
