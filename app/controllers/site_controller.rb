class SiteController < ApplicationController
  allow_unauthenticated_access only: %i[ index landing about ]
  before_action :redirect_to_landing_unless_authenticated, only: :index
  before_action :require_admin, only: :admin
  layout "sessions", only: :landing

  def index
    @prescriptions = Current.user.prescriptions.includes(
      { medication_version: { medication_version_ingredients: :active_ingredient } },
      { medication: [ :release_profile, :medication_release_profile, :active_ingredients ] },
      :recent_doses
    ).order(active: :desc)

    @concentrations = PkCalculator.current_concentrations(@prescriptions)
  end

  def timeline
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

  def calendar
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

  def admin
  end

  def landing
  end

  def about
  end

  private
    def redirect_to_landing_unless_authenticated
      redirect_to :landing unless authenticated?
    end
end
