class Prescriptions::GraphController < Prescriptions::BaseController
  MAX_HOURS = 24 * 90 # 90 days in either direction

  def show
    @past   = clamp_hours(params[:past],   @prescription.preview_past)
    @future = clamp_hours(params[:future], @prescription.preview_future)
    @plot   = PkCalculator.for_prescription(@prescription, past: @past, future: @future)
  end

  private
    def clamp_hours(value, fallback)
      hours = value.present? ? value.to_i : fallback.to_i
      hours.clamp(0, MAX_HOURS)
    end
end
