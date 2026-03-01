class MedicationsController < ApplicationController
  before_action :set_medication, except: %i[ new create ]
  before_action :require_admin,  except: :show

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

  def edit
  end

  def destroy
    @medication.destroy!

    redirect_to root_path, notice: "#{@medication.name} is gone now"
  end

  def update
    if @medication.update medication_params
      redirect_to @medication, notice: "Applied your super cool changes ^^"
    else
      render :edit, status: :unprocessable_content
    end
  end

  private
    def set_medication
      @medication = Medication.find(params[:id])
    end

    def medication_params
      params.expect(medication: [ :name, :form_id, :labeler_id, :notes, active_ingredient_ids: [], category_ids: [] ])
    end
end
