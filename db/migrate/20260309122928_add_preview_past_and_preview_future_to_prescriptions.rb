class AddPreviewPastAndPreviewFutureToPrescriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :prescriptions, :preview_past, :float, null: false, default: 24
    add_column :prescriptions, :preview_future, :float, null: false, default: 40
  end
end
