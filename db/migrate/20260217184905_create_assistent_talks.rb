class CreateAssistentTalks < ActiveRecord::Migration[8.1]
  def change
    create_table :assistent_talks do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :talk, null: false

      t.timestamps
    end
  end
end
