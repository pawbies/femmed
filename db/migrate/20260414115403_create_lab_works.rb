class CreateLabWorks < ActiveRecord::Migration[8.1]
  def change
    create_table :lab_works do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :taken_at, null: false

      t.timestamps
    end
    add_index :lab_works, :taken_at
  end
end
