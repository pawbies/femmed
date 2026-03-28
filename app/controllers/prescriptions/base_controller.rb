class Prescriptions::BaseController < ApplicationController
  before_action :set_prescription

  private
    def set_prescription
      @prescription = Current.user.prescriptions.find(params[:prescription_id])
    end

    def require_active_prescription
      redirect_back fallback_location: root_path, notice: t("prescriptions.base.prescription_inactive") unless @prescription.active?
    end
end
