class Developments::BloodPressureReadingsController < Developments::BaseController
  def index
    @bpr = Current.user.blood_pressure_readings.order(measured_at: :desc)
    @prescriptions = Current.user.prescriptions
  end
end
