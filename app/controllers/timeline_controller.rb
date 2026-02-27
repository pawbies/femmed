class TimelineController < ApplicationController
  def index
    @date = Date.parse(params[:date]) rescue Date.today
    if @date.future?
      redirect_back fallback_location: timeline_path(date: Date.today), notice: "This didnt even happen yet O.O"
      return
    end

    doses = Current.user.doses.where(taken_at: @date.all_day)
    @doses_by_hour = (0..23).index_with { |hour| [] }
    doses.each { |d| @doses_by_hour[d.taken_at.hour] << d }
  end
end
