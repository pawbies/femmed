class AddPfpToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :pfp, :integer, null: false, default: 0
  end
end
