class AddHalfLifeToActiveIngredients < ActiveRecord::Migration[8.1]
  def change
    add_column :active_ingredients, :half_life, :float
  end
end
