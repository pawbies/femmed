class PrescriptionsController < ApplicationController
  before_action :set_prescription, except: :create

  def create
    @prescription = Current.user.prescriptions.new(**prescription_create_params, amount: 1, active: true)
    if @prescription.save
      redirect_to prescription_doses_path(@prescription)
    else
      redirect_back fallback_location: @prescription.medication, alert: "Something went wrong :("
    end
  end

  def edit
  end

  def update
    if @prescription.update prescription_update_params
      redirect_to edit_prescription_path(@prescription), notice: "Updated your prescription for ya"
    else
      redirect_to edit_prescription_path(@prescription), alert: "Something went wrong :("
    end
  end

  def destroy
    @prescription.destroy!
    redirect_to root_path, notice: "Removed #{@prescription.full_name}"
  end

  private
    def set_prescription
      @prescription = Current.user.prescriptions.find(params[:id])
    end

    def prescription_create_params
      params.expect(prescription: [ :medication_version_id ])
    end

    def prescription_update_params
      params.expect(prescription: [ :amount, :active, :pack_tracking_enabled, :preview_past, :preview_future ])
    end
end
