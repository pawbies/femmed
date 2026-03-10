class PrescriptionsController < ApplicationController
  before_action :set_user
  before_action :require_own_user
  before_action :set_prescription, except: :create

  def create
    @prescription = @user.prescriptions.new(**prescription_create_params, amount: 1, active: true)
    if @prescription.save
      redirect_to user_prescription_path(@user, @prescription)
    else
      redirect_back fallback_location: @prescription.medication, alert: "Something went wrong :("
    end
  end

  def show
  end

  def update
    if @prescription.update prescription_update_params
      redirect_to user_prescription_path(@user, @prescription, page: "Settings"), notice: "Updated your prescription for ya"
    else
      redirect_to user_prescription_path(@user, @prescription, page: "Settings"), alert: "Something went wrong :("
    end
  end

  def destroy
    @prescription.destroy!
    redirect_to root_path, notice: "Removed #{@prescription.full_name}"
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_prescription
      @prescription = @user.prescriptions.find(params[:id])
    end

    def require_own_user
      redirect_to root_path, notice: "UwU whatcha doin threre" unless @user.id == Current.user.id
    end

    def prescription_create_params
      params.expect(prescription: [ :medication_version_id ])
    end

    def prescription_update_params
      params.expect(prescription: [ :amount, :active, :pack_tracking_enabled, :preview_past, :preview_future ])
    end
end
