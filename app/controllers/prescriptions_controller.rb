class PrescriptionsController < ApplicationController
  before_action :set_prescription, except: %i[ index create ]

  def index
    @prescriptions = Current.user.prescriptions.includes(
      { medication_version: { medication_version_ingredients: :active_ingredient } },
      { medication: [ :release_profile, :medication_release_profile, :active_ingredients ] },
      :recent_doses,
      :doses
    ).order(prescriptions: { active: :desc }, doses: { taken_at: :desc })
  end

  def create
    @prescription = Current.user.prescriptions.new(**prescription_create_params, amount: 1, active: true)
    if @prescription.save
      redirect_to prescription_doses_path(@prescription)
    else
      redirect_back fallback_location: @prescription.medication, alert: t(".something_went_wrong")
    end
  end

  def edit
  end

  def update
    if @prescription.update prescription_update_params
      redirect_to edit_prescription_path(@prescription), notice: t(".updated")
    else
      redirect_to edit_prescription_path(@prescription), alert: t(".something_went_wrong")
    end
  end

  def destroy
    @prescription.destroy!
    redirect_to root_path, notice: t(".removed", name: @prescription.full_name)
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
