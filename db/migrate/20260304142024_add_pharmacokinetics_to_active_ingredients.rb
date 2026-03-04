class AddPharmacokineticsToActiveIngredients < ActiveRecord::Migration[8.1]
  def change
    add_column :active_ingredients, :absorption_rate, :float
    add_column :active_ingredients, :volume_of_distribution, :float
  end
end
