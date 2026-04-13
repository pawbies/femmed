class Developments::BloodPressureReadingsController < Developments::BaseController
  before_action :set_blood_pressure_reading, except: %i[ index ]

  def index
    @bpr = Current.user.blood_pressure_readings.order(measured_at: :desc)
    @prescriptions = Current.user.prescriptions
  end

  def show
  end

  private
    def set_blood_pressure_reading
      @bpr = Current.user.blood_pressure_readings.find(params[:id])
    end
end
