class CreateReleaseProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :release_profiles do |t|
      t.string :name

      t.timestamps
    end
    add_index :release_profiles, :name, unique: true
  end
end
