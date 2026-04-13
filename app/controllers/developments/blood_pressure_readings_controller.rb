class Developments::BloodPressureReadingsController < Developments::BaseController
  def index
    @pagy, @bpr = pagy(:offset, Current.user.blood_pressure_readings.order(measured_at: :desc))
    @prescriptions = Current.user.prescriptions
  end
end
