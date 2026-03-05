class RenameAbsorptionRateToReleaseDurationInMedicationReleaseProfile < ActiveRecord::Migration[8.1]
  def change
    rename_column :medication_release_profiles, :absorption_rate, :release_duration
  end
end
