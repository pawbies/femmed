class CreateForms < ActiveRecord::Migration[8.1]
  def change
    create_table :forms do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :forms, :name, unique: true
  end
end
