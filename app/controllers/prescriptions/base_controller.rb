class Prescriptions::BaseController < ApplicationController
  before_action :set_prescription

  private
    def set_prescription
      @prescription = Current.user.prescriptions.find(params[:prescription_id])
    end

    def require_active_prescription
      redirect_back fallback_location: root_path, notice: "This requires an active prescription" unless @prescription.active?
    end
end
