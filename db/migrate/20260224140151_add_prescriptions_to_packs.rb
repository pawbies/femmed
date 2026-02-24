class AddPrescriptionsToPacks < ActiveRecord::Migration[8.1]
  def change
    add_reference :packs, :prescription, null: false, foreign_key: true
  end
end
