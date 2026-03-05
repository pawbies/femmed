class CreateMedicationReleaseProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :medication_release_profiles do |t|
      t.references :medication, null: false, foreign_key: true
      t.references :release_profile, null: false, foreign_key: true
      t.float :absorption_rate
      t.float :delay

      t.timestamps
    end
  end
end
