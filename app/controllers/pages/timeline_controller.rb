class Pages::TimelineController < Pages::BaseController
  def show
    @date = begin
      Date.parse(params[:date])
    rescue ArgumentError, TypeError
      Date.today
    end

    doses = Current.user.doses.where(taken_at: @date.all_day).includes(:prescription).to_a
    @doses_by_hour = (0..23).index_with { |hour| [] }
    doses.each { |d| @doses_by_hour[d.taken_at.hour] << d }

    @planned_by_hour = (0..23).index_with { |hour| [] }
    Current.user.prescriptions.where.not(routine: nil).each do |prescription|
      prescription_doses = doses.select { |d| d.prescription_id == prescription.id }
      prescription.routine.occurrences_between(@date.beginning_of_day, @date.end_of_day).each do |time|
        covered = prescription_doses.any? { |d| (d.taken_at - time).abs <= 1.hour }
        @planned_by_hour[time.hour] << { prescription: prescription, time: time } unless covered
      end
    rescue StandardError
      next
    end
  end
end
