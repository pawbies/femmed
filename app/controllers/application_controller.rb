class ApplicationController < ActionController::Base
  include Authentication, Authorization, Pagy::Method
  before_action :set_locale
  before_action :set_timezone

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private
    def set_locale
      I18n.locale = Current.user.language if authenticated?
    rescue I18n::InvalidLocale
      I18n.locale = I18n.default_locale
    end

    def set_timezone
      timezone = cookies[:timezone]
      Time.zone = ActiveSupport::TimeZone[timezone] if timezone.present?
    rescue ArgumentError, TZInfo::InvalidTimezoneIdentifier
      Time.zone = "UTC"
    end
end
