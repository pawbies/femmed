class AddBioavailabilityToMedicationVersionIngredients < ActiveRecord::Migration[8.1]
  def change
    add_column :medication_version_ingredients, :bioavailability, :float, null: false, default: 1.0
  end
end
