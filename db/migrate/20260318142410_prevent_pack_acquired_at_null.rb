class PreventPackAcquiredAtNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :packs, :acquired_at, false
  end
end
