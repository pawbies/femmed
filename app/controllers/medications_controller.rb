class MedicationsController < ApplicationController
  before_action :medication

  def show
  end

  private
    def set_medication
      @medication = Medication.find(params[:id])
    end
end
