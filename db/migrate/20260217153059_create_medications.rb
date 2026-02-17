class CreateMedications < ActiveRecord::Migration[8.1]
  def change
    create_table :medications do |t|
      t.string :name, null: false
      t.references :labeler, null: true, foreign_key: true
      t.references :form, null: false, foreign_key: true

      t.timestamps
    end
  end
end
