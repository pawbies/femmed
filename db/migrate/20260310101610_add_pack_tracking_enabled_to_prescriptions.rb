class AddPackTrackingEnabledToPrescriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :prescriptions, :pack_tracking_enabled, :boolean, null: false, default: true
  end
end
