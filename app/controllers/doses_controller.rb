class DosesController < ApplicationController
  before_action :set_prescription
  before_action :set_dose, only: %i[ edit update destroy ]
  before_action :require_own_prescription
  before_action :require_non_empty_stash, only: %i[ new create ]

  def new
    @dose = @prescription.doses.new(amount_taken: @prescription.amount, taken_at: Time.current.change(sec: 0))
  end

  def create
    @dose = @prescription.doses.new dose_params

    if @dose.save
      redirect_to @prescription, notice: "Logged it for ya ^^"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @dose.update dose_params
      redirect_to @prescription, notice: "Updated #{@prescription.full_name} dose"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @dose.destroy!

    redirect_to @prescription
  end

  private
    def set_prescription
      @prescription = Prescription.find(params[:prescription_id])
    end

    def set_dose
      @dose = @prescription.doses.find(params[:id])
    end

    def require_own_prescription
      redirect_to root_path, alert: "Grrrrr!" unless @prescription.user.id == Current.user.id
    end

    def require_non_empty_stash
      unless @prescription.remaining_units > 0
        redirect_back fallback_location: @prescription, notice: "You don't have anything to take cutie >.<"
      end
    end

    def dose_params
      params.expect(dose: [ :amount_taken, :taken_at ])
    end
end
