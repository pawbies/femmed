class CreateJoinTableMedicationsActiveIngredients < ActiveRecord::Migration[8.1]
  def change
    create_join_table :medications, :active_ingredients do |t|
      t.index [ :medication_id, :active_ingredient_id ]
      # t.index [:active_ingredient_id, :medication_id]
    end
  end
end
