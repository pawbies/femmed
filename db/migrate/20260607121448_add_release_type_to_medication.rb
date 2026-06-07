class AddReleaseTypeToMedication < ActiveRecord::Migration[8.1]
  def up
    add_column :medications, :release_type, :integer
    add_column :medications, :delay, :float
    add_column :medications, :release_duration, :float

    execute <<~SQL
      UPDATE medications SET
        release_type = COALESCE((
          SELECT CASE rp.name
                   WHEN 'Immediate' THEN 0
                   WHEN 'Bimodal'   THEN 1
                   WHEN 'Extended'  THEN 2
                 END
          FROM medication_release_profiles mrp
          JOIN release_profiles rp ON rp.id = mrp.release_profile_id
          WHERE mrp.medication_id = medications.id
        ), 0),
        delay = (
          SELECT mrp.delay FROM medication_release_profiles mrp
          WHERE mrp.medication_id = medications.id
        ),
        release_duration = (
          SELECT mrp.release_duration FROM medication_release_profiles mrp
          WHERE mrp.medication_id = medications.id
        )
    SQL

    drop_table :medication_release_profiles
    drop_table :release_profiles
  end

  def down
    create_table :release_profiles do |t|
      t.string :name
      t.timestamps
      t.index :name, unique: true
    end

    create_table :medication_release_profiles do |t|
      t.references :medication,      null: false, foreign_key: true
      t.references :release_profile, null: false, foreign_key: true
      t.float :delay
      t.float :release_duration
      t.timestamps
    end

    remove_column :medications, :release_type
    remove_column :medications, :delay
    remove_column :medications, :release_duration
  end
end
