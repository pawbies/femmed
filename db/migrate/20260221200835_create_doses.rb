class CreateDoses < ActiveRecord::Migration[8.1]
  def change
    create_table :doses do |t|
      t.references :pack, null: false, foreign_key: true
      t.float :amount_taken, null: false
      t.datetime :taken_at, null: false

      t.timestamps
    end
  end
end
