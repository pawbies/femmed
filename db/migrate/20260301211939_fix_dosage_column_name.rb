class FixDosageColumnName < ActiveRecord::Migration[8.1]
  def change
    change_column :prescriptions, :dosage, :float
    rename_column :prescriptions, :dosage, :amount
  end
end
