class CreateMedicationVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :medication_versions do |t|
      t.references :medication, null: false, foreign_key: true
      t.string :added_name, null: false
      t.integer :strength_per_dose
      t.string :ndc, null: false

      t.timestamps
    end
  end
end
