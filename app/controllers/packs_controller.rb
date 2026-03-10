class PacksController < ApplicationController
  before_action :set_user
  before_action :require_own_user
  before_action :set_prescription
  before_action :set_pack, except: %i[ new create ]
  before_action :require_active_prescription
  before_action :require_pack_tracking_enabled

  def new
    @pack = @prescription.packs.new(aquired_at: Date.today)
  end

  def create
    @pack = @prescription.packs.new pack_params

    if @pack.save
      redirect_to user_prescription_path(@user, @prescription, page: "Packs")
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @pack.update pack_params
      redirect_to user_prescription_path(@user, @prescription, page: "Packs")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @pack.destroy!
    redirect_to user_prescription_path(@user, @prescription, page: "Packs")
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

    def require_own_user
      redirect_to root_path, alert: "Grrrrr!" unless @user.id == Current.user.id
    end

    def set_prescription
      @prescription = @user.prescriptions.find(params[:prescription_id])
    end

    def set_pack
      @pack = @prescription.packs.find(params[:id])
    end

    def require_active_prescription
      redirect_back fallback_location: root_path, notice: "This requires an active prescription" unless @prescription.active?
    end

    def require_pack_tracking_enabled
      redirect_back fallback_location: root_path, notice: "This requires the pack tracking feature" unless @prescription.pack_tracking_enabled?
    end

    def pack_params
      params.expect(pack: [ :amount, :aquired_at ])
    end
end
