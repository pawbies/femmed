class DropAssistentTalks < ActiveRecord::Migration[8.1]
  def change
    drop_table :assistent_talks
  end
end
