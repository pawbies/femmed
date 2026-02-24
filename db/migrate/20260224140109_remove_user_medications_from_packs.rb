class RemovePrescriptionsFromPacks < ActiveRecord::Migration[8.1]
  def change
    remove_reference :packs, :user_medication
  end
end
