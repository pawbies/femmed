class CreateDoses < ActiveRecord::Migration[8.1]
  def change
    create_table :doses do |t|
      t.references :user_medication, null: false, foreign_key: true
      t.integer :dosage
      t.datetime :taken_at

      t.timestamps
    end
  end
end
