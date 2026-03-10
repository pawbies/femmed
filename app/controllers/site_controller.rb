class SiteController < ApplicationController
  allow_unauthenticated_access
  before_action :redirect_to_landing_unless_authenticated, only: :index
  layout "sessions", only: :landing

  content_security_policy only: :index do |policy|
    policy.style_src :self, :https, :unsafe_inline
  end
  before_action :diable_css_nonce, only: :index

  def index
    @assistent_intro = !Current.user.assistent_talks.exists?(talk: :introduction)
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
