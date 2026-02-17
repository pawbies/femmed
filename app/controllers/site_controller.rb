class SiteController < ApplicationController
  allow_unauthenticated_access
  before_action :redirect_to_landing_unless_authenticated, only: :index
  layout "sessions", only: :landing

  def index
    @show_assistent = params[:assistent] == "first-visit"
  end

  def landing
  end

  private
    def redirect_to_landing_unless_authenticated
      redirect_to :landing unless authenticated?
    end
end
