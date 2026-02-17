class CreateJoinTableMedicationsReferences < ActiveRecord::Migration[8.1]
  def change
    create_join_table :medications, :references do |t|
      # t.index [:medication_id, :reference_id]
      # t.index [:reference_id, :medication_id]
    end
  end
end
