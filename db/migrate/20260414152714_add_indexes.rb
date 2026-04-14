class AddIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :prescription_doses, :taken_at
    add_index :prescription_packs, :acquired_at
    add_index :blood_pressure_readings, :measured_at
  end
end
