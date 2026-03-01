class CalendarController < ApplicationController
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @mode = params[:mode] == "week" ? "week" : "month"
  end
end
