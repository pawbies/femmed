class DropReferences < ActiveRecord::Migration[8.1]
  def change
    drop_table :references
    drop_table :medications_references
  end
end
