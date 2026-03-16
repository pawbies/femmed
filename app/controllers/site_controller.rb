class SiteController < ApplicationController
  allow_unauthenticated_access only: %i[ index landing about ]
  before_action :redirect_to_landing_unless_authenticated, only: :index
  before_action :require_admin, only: :admin
  layout "sessions", only: :landing

  content_security_policy only: :index do |policy|
    policy.style_src :self, :https, :unsafe_inline
  end
  before_action :diable_css_nonce, only: :index

  def index
  end

  def timeline
    @date = Date.parse(params[:date]) rescue Date.today
    if @date.future?
      redirect_back fallback_location: timeline_path(date: Date.today), notice: "This didnt even happen yet O.O"
      return
    end

    doses = Current.user.doses.where(taken_at: @date.all_day).includes(:prescription)
    @doses_by_hour = (0..23).index_with { |hour| [] }
    doses.each { |d| @doses_by_hour[d.taken_at.hour] << d }
  end

  def calendar
    @date = Date.parse(params[:date]) rescue Date.today
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

    def diable_css_nonce
     request.content_security_policy_nonce_directives = %w[script-src]
    end
end
