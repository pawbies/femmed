class AddRoutineToPrescriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :prescriptions, :routine, :text
  end
end
