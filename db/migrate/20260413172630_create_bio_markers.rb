class CreateBioMarkers < ActiveRecord::Migration[8.1]
  def change
    create_table :bio_markers do |t|
      t.text :name, null: false
      t.text :abbreviation
      t.text :description
      t.text :min_reference_value
      t.text :max_reference_value
      t.integer :unit, null: false

      t.timestamps
    end
    add_index :bio_markers, :name, unique: true
  end
end
