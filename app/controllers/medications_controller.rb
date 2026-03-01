class MedicationsController < ApplicationController
  before_action :set_medication, only: :show
  before_action :require_admin,  only: %i[ new create ]

  def new
    @medication = Medication.new
  end

  def create
    @medication = Medication.new medication_params

    if @medication.save
      redirect_to @medication, notice: "Created #{@medication.name}"
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  private
    def set_medication
      @medication = Medication.find(params[:id])
    end

    def medication_params
      params.expect(medication: [ :name, :form_id, :labeler_id, :notes, active_ingredient_ids: [], category_ids: [] ])
    end
end
