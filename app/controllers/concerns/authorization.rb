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
      redirect_to root_path, notice: "You're cute but not allowed here" unless admin?
    end
end
