class DosesController < ApplicationController
  before_action :fetch_prescription_by_id
  before_action :require_own_prescription

  def new
    @dose = @prescription.doses.new(taken_at: Time.current.change(sec: 0))
  end

  def create
    @dose = @prescription.doses.new dose_params

    if @dose.save
      redirect_to @prescription, notice: "Logged it for ya ^^"
    else
      render :new, status: :unprocessable_content
    end
  end

  private
    def fetch_prescription_by_id
      @prescription = Prescription.find(params[:prescription_id])
    end

    def require_own_prescription
      redirect_to root_path, alert: "Grrrrr!" unless @prescription.user.id == Current.user.id
    end

    def dose_params
      params.expect(dose: [ :amount_taken, :taken_at ])
    end
end
