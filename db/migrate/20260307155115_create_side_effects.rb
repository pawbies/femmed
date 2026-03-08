class CreateSideEffects < ActiveRecord::Migration[8.1]
  def change
    create_table :side_effects do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
