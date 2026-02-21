class CreatePacks < ActiveRecord::Migration[8.1]
  def change
    create_table :packs do |t|
      t.references :user_medication, null: false, foreign_key: true
      t.integer :amount, null: false
      t.date :aquired_at

      t.timestamps
    end
  end
end
