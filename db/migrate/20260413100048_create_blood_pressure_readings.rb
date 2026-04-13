class CreateBloodPressureReadings < ActiveRecord::Migration[8.1]
  def change
    create_table :blood_pressure_readings do |t|
      t.references :user, null: false, foreign_key: true
      t.text :systolic, null: false
      t.text :diastolic, null: false
      t.text :bpm
      t.datetime :measured_at

      t.timestamps
    end
  end
end
