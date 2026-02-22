class UserMedicationsController < ApplicationController
  before_action :fetch_medication_and_medication_version_from_id, except: :destroy
  before_action :fetch_user_medication_by_id, only: :destroy

  def new
    @user_medication = UserMedication.new
  end

  def create
    @user_medication = UserMedication.new(**user_medication_params, medication_version: @medication_version)
    if @user_medication.user.id != Current.user.id
      flash.now[:alert] = "Heyyyyy! Dont do that!"
      render :new, status: :forbidden
    elsif @user_medication.save
      redirect_to @medication, notice: "Added #{@medication.name} hehe"
    else
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    if @user_medication.user.id == Current.user.id
      @user_medication.destroy!
      redirect_back fallback_location: @user_medication.medication_version.medication, notice: "Removed #{@user_medication.medication_version.full_name}"
    else
      redirect_to root_path, notice: ">:("
    end
  end

  private
    def fetch_medication_and_medication_version_from_id
      @medication_version = MedicationVersion.find(params[:medication_version_id])
      @medication = @medication_version.medication
    end

    def fetch_user_medication_by_id
      @user_medication = UserMedication.find(params[:id])
    end

    def user_medication_params
      params.expect(user_medication: [ :user_id, :dosage ])
    end
end
