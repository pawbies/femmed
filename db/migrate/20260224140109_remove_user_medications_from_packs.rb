class RemovePrescriptionsFromPacks < ActiveRecord::Migration[8.1]
  def change
    remove_column :packs, :user_medication_id
  end
end
