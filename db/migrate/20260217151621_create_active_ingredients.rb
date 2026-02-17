class CreateActiveIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :active_ingredients do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :active_ingredients, :name, unique: true
  end
end
