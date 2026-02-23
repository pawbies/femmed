class SiteController < ApplicationController
  allow_unauthenticated_access
  before_action :redirect_to_landing_unless_authenticated, only: :index
  layout "sessions", only: :landing

  def index
    @assistent_intro = !Current.user.assistent_talks.exists?(talk: :introduction)

    flash.now[:notice] = "Hello World"
    flash.now[:alert] = "Bye World"
  end

  def landing
  end

  private
    def redirect_to_landing_unless_authenticated
      redirect_to :landing unless authenticated?
    end
end
