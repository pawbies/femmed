class Developments::BloodPressureReadingsController < Developments::BaseController
  before_action :set_blood_pressure_reading, except: %i[ index new create ]

  def index
    @bpr = Current.user.blood_pressure_readings.order(measured_at: :desc)
    @prescriptions = Current.user.prescriptions
  end

  def new
    @bpr = Current.user.blood_pressure_readings.new(measured_at: Time.now)
  end

  def create
    @bpr = Current.user.blood_pressure_readings.new(blood_pressure_reading_params)

    if @bpr.save
      redirect_to @bpr
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  def edit
  end

  def update
    if @bpr.update blood_pressure_reading_params
      redirect_to @bpr
    else
      render :edit, status: :unprocessable_content
    end
  end

  private
    def set_blood_pressure_reading
      @bpr = Current.user.blood_pressure_readings.find(params[:id])
    end

    def blood_pressure_reading_params
      params.expect(blood_pressure_reading: [ :systolic, :diastolic, :bpm, :measured_at ])
    end
end
