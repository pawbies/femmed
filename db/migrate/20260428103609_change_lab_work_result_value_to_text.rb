class ChangeLabWorkResultValueToText < ActiveRecord::Migration[8.1]
  def change
    change_column :lab_work_results, :value, :text
  end
end
