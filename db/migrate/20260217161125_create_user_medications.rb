class CreateUserMedications < ActiveRecord::Migration[8.1]
  def change
    create_table :user_medications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :medication_version, null: false, foreign_key: true
      t.integer :dosage, null: false

      t.timestamps
    end
  end
end
