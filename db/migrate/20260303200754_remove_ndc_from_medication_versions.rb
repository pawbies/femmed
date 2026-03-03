class RemoveNdcFromMedicationVersions < ActiveRecord::Migration[8.1]
  def change
    remove_column :medication_versions, :ndc, :string
  end
end
