class LegalController < ApplicationController
  allow_unauthenticated_access
  layout "sessions"

  def imprint
  end

  def terms_of_service
  end

  def privacy
  end
end
