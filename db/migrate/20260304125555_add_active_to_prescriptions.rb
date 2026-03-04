class AddActiveToPrescriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :prescriptions, :active, :boolean, default: true, null: false
  end
end
