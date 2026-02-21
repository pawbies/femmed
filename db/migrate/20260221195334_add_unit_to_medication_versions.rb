class AddUnitToMedicationVersions < ActiveRecord::Migration[8.1]
  def change
    add_column :medication_versions, :unit, :integer, default: 0
  end
end
