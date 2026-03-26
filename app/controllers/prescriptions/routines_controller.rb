class Prescriptions::RoutinesController < Prescriptions::BaseController
  def new
  end

  def edit
    @routine_data = schedule_to_form_data(@prescription.routine)
  end

  def create
    schedule = build_schedule
    if schedule.nil?
      flash.now[:notice] = "Sorry >.< something went wrong"
      render :new, status: :unprocessable_content
    elsif @prescription.update routine: schedule
      redirect_to prescription_routine_path(@prescription)
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    schedule = build_schedule
    if schedule.nil?
      @routine_data = schedule_to_form_data(@prescription.routine)
      flash.now[:notice] = "Sorry >.< something went wrong"
      render :edit, status: :unprocessable_content
    elsif @prescription.update routine: schedule
      redirect_to prescription_routine_path(@prescription)
    else
      @routine_data = schedule_to_form_data(@prescription.routine)
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @prescription.update! routine: nil

    redirect_to prescription_routine_path(@prescription)
  end

  private
    def routine_params
      params.permit(
        :routine_type,
        :routine_interval,
        :routine_hourly_interval,
        :routine_start,
        routine_days: [],
        routine_times: []
      )
    end

    def schedule_to_form_data(schedule)
      return {} unless schedule
      rule = schedule.recurrence_rules.first
      return {} unless rule

      h = rule.to_hash
      data = { routine_start: schedule.start_time.to_date.to_s }

      case rule
      when IceCube::DailyRule
        if h[:interval] == 1
          data[:routine_type] = "daily"
        else
          data[:routine_type] = "interval"
          data[:routine_interval] = h[:interval]
        end
      when IceCube::WeeklyRule
        data[:routine_type] = "weekly"
        data[:routine_days] = (h.dig(:validations, :day) || []).map { |d| Date::DAYNAMES[d].downcase }
      when IceCube::HourlyRule
        data[:routine_type] = "hourly"
        data[:routine_hourly_interval] = h[:interval]
      end

      hours = h.dig(:validations, :hour_of_day) || []
      minutes = h.dig(:validations, :minute_of_hour) || []
      if hours.any?
        data[:routine_times] = hours.zip(minutes).map { |hr, min| "#{hr.to_s.rjust(2, "0")}:#{min.to_s.rjust(2, "0")}" }
      end

      data
    end

    def build_schedule
      return nil if routine_params[:routine_type].blank?

      start = if routine_params[:routine_start].present?
        Time.zone.parse(routine_params[:routine_start])
      else
        Time.zone.now.beginning_of_day
      end

      schedule = IceCube::Schedule.new(start)

      rule = case routine_params[:routine_type]
      when "daily"
        IceCube::Rule.daily
      when "interval"
        IceCube::Rule.daily(routine_params[:routine_interval].to_i)
      when "weekly"
        days = (routine_params[:routine_days] || []).compact_blank.map(&:to_sym)
        return nil if days.empty?
        IceCube::Rule.weekly.day(*days)
      when "hourly"
        IceCube::Rule.hourly(routine_params[:routine_hourly_interval].to_i)
      end

      return nil unless rule

      if routine_params[:routine_type] != "hourly"
        hours = (routine_params[:routine_times] || []).compact_blank.map { |t| t.split(":").first.to_i }
        minutes = (routine_params[:routine_times] || []).compact_blank.map { |t| t.split(":").last.to_i }
        rule = rule.hour_of_day(*hours).minute_of_hour(*minutes) if hours.any?
      end
      schedule.add_recurrence_rule(rule)
      schedule
    end
end
