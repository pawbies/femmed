class MedicationsController < ApplicationController
  before_action :fetch_medication_by_id

  def show
  end

  private
    def fetch_medication_by_id
      @medication = Medication.find(params[:id])
    end
end
