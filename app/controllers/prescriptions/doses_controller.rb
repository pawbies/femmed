class Prescriptions::DosesController < Prescriptions::BaseController
  before_action :require_active_prescription, except: :index
  before_action :set_dose, only: %i[ edit update destroy ]
  before_action :require_non_empty_stash, only: %i[ new create ]

  def index
    @pagy, @doses = pagy(:offset, @prescription.doses.order(taken_at: :desc), limit: 10)
  end

  def new
    @dose = @prescription.doses.new(amount_taken: @prescription.amount, taken_at: Time.current.change(sec: 0))
  end

  def create
    @dose = @prescription.doses.new dose_params

    if @dose.save
      redirect_to prescription_doses_path(@prescription)
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @dose.update dose_params
      redirect_to prescription_doses_path(@prescription)
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @dose.destroy!

    redirect_to prescription_doses_path(@prescription)
  end

  private
    def set_dose
      @dose = @prescription.doses.find(params[:id])
    end

    def require_non_empty_stash
      unless !@prescription.pack_tracking_enabled? || @prescription.remaining_units > 0
        redirect_back fallback_location: @prescription, notice: "You don't have anything to take cutie >.<"
      end
    end

    def dose_params
      params.expect(prescription_dose: [ :amount_taken, :taken_at ])
    end
end
