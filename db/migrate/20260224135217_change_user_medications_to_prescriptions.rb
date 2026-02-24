class ChangePrescriptionsToPrescriptions < ActiveRecord::Migration[8.1]
  def change
    rename_table :user_medications, :prescriptions
  end
end
