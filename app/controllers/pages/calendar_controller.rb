class Pages::CalendarController < Pages::BaseController
  def show
    @date = begin
      Date.parse(params[:date])
    rescue ArgumentError, TypeError
      Date.today
    end
    @mode = params[:mode] == "week" ? "week" : "month"

    range = if @mode == "week"
      @date.beginning_of_week(:monday)..@date.end_of_week(:monday)
    else
      @date.beginning_of_month..@date.end_of_month
    end

    @dose_dates = Current.user.doses
      .where(taken_at: range)
      .pluck(:taken_at)
      .map(&:to_date)
      .to_set
  end
end
