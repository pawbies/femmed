class AddPrescriptionsToDoses < ActiveRecord::Migration[8.1]
  def change
    add_reference :doses, :prescription, null: false, foreign_key: true
  end
end
