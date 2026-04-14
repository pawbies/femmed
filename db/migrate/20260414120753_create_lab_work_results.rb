class CreateLabWorkResults < ActiveRecord::Migration[8.1]
  def change
    create_table :lab_work_results do |t|
      t.references :lab_work, null: false, foreign_key: true
      t.references :bio_marker, null: false, foreign_key: true
      t.float :value, null: false

      t.timestamps
    end
  end
end
