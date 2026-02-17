class CreateJoinTableMedicationsCategories < ActiveRecord::Migration[8.1]
  def change
    create_join_table :medications, :categories do |t|
      # t.index [:medication_id, :category_id]
      # t.index [:category_id, :medication_id]
    end
  end
end
