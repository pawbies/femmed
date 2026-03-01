class ApplicationController < ActionController::Base
  include Authentication, Authorization
  before_action :set_timezone

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private
    def set_timezone
      timezone = cookies[:timezone]
      Time.zone = ActiveSupport::TimeZone[timezone] if timezone.present?
    rescue
      Time.zone = "UTC"
    end
end
