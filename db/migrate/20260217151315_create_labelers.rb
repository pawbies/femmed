class CreateLabelers < ActiveRecord::Migration[8.1]
  def change
    create_table :labelers do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :labelers, :name, unique: true
  end
end
