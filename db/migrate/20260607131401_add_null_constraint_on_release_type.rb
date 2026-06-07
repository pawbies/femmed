class AddNullConstraintOnReleaseType < ActiveRecord::Migration[8.1]
  def change
    execute "UPDATE medications SET release_type = 0 WHERE release_type IS NULL"
    change_column :medications, :release_type, :integer, null: false, default: 0
  end
end
