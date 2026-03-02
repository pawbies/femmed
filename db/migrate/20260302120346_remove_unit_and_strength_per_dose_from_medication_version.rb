class RemoveUnitAndStrengthPerDoseFromMedicationVersion < ActiveRecord::Migration[8.1]
  def change
    remove_column :medication_versions, :unit, :integer
    remove_column :medication_versions, :strength_per_dose, :integer
  end
end
