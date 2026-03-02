class CreateMedicationVersionIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :medication_version_ingredients do |t|
      t.references :medication_version, null: false, foreign_key: true
      t.references :active_ingredient, null: false, foreign_key: true
      t.float :amount
      t.integer :unit

      t.timestamps
    end
  end
end
