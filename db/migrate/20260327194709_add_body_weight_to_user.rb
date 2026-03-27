class AddBodyWeightToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :body_weight, :float, null: false, default: 80
  end
end
