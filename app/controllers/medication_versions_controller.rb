class MedicationVersionsController < ApplicationController
  before_action :require_admin
  before_action :set_medication

  def create
    medication_version = @medication.versions.new medication_version_params
    if medication_version.save
      redirect_to @medication, notice: "Created #{medication_version.full_name}"
    else
      redirect_to @medication, alert: "Something went wrong :("
    end
  end

  private
    def medication_version_params
      params.expect(medication_version: [ :added_name, :strength_per_dose, :unit, :ndc ])
    end

    def set_medication
      @medication = Medication.find(params[:medication_id])
    end
end
