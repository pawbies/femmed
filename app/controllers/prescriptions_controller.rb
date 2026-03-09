class PrescriptionsController < ApplicationController
  before_action :set_medication_and_medication_version,   only: :create
  before_action :set_prescription,                      except: :create
  before_action :require_own_prescription,              except: :create

  def create
    @prescription = Prescription.new(user: Current.user, amount: 1, medication_version: @medication_version, active: true)
    if @prescription.save
      redirect_to @prescription, notice: "Added #{@medication.name} hehe"
    else
      redirect_back fallback_location: @medication, alert: "Something went wrong :("
    end
  end

  def show
  end

  def update
    if @prescription.update prescription_update_params
      redirect_to prescription_path(@prescription, page: "Settings"), notice: "Updated your prescription for ya"
    else
      redirect_to prescription_path(@prescription, page: "Settings"), alert: "Something went wrong :("
    end
  end

  def destroy
    @prescription.destroy!
    redirect_to root_path, notice: "Removed #{@prescription.full_name}"
  end

  private
    def set_medication_and_medication_version
      @medication_version = MedicationVersion.find(params[:medication_version_id])
      @medication = @medication_version.medication
    end

    def set_prescription
      @prescription = Current.user.prescriptions.find(params[:id])
    end

    def prescription_update_params
      params.expect(prescription: [ :amount, :active, :preview_past, :preview_future ])
    end

    def require_own_prescription
      redirect_to root_path, alert: "Hey! That's not yours UwU" unless @prescription.user.id == Current.user.id
    end
end
