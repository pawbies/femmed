class DropSymptoms < ActiveRecord::Migration[8.1]
  def change
    drop_table :symptoms
  end
end
