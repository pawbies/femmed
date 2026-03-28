module Authorization
  extend ActiveSupport::Concern

  included do
    helper_method :admin?
  end

  private
    def admin?
      Current.user&.admin?
    end

    def require_admin
      redirect_to root_path, alert: t("concerns.authorization.not_allowed") unless admin?
    end
end
