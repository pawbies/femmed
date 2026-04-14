class BloodPressureReadingsController < ApplicationController
  before_action :set_blood_pressure_reading, except: %i[ index new create ]

  def index
    @period = params[:period].presence_in(%w[week month year]) || "all"
    @bpr = Current.user.blood_pressure_readings.order(measured_at: :desc)
    @bpr = case @period
    when "week"  then @bpr.where(measured_at: 1.week.ago..)
    when "month" then @bpr.where(measured_at: 1.month.ago..)
    when "year"  then @bpr.where(measured_at: 1.year.ago..)
    else @bpr
    end
    @prescriptions = Current.user.prescriptions
  end

  def new
    @bpr = Current.user.blood_pressure_readings.new(measured_at: Time.current.change(sec: 0))
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

  def destroy
    @bpr.destroy!

    redirect_to blood_pressure_readings_path, notice: t(".deleted")
  end

  private
    def set_blood_pressure_reading
      @bpr = Current.user.blood_pressure_readings.find(params[:id])
    end

    def blood_pressure_reading_params
      params.expect(blood_pressure_reading: [ :systolic, :diastolic, :bpm, :measured_at ])
    end
end
