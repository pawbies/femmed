class PacksController < ApplicationController
  before_action :set_prescription
  before_action :require_own_prescription
  before_action :require_active_prescription

  def new
    @pack = @prescription.packs.new(aquired_at: Date.today)
  end

  def create
    @pack = @prescription.packs.new pack_params

    if @pack.save
      redirect_to prescription_path(@prescription, page: "Packs")
    else
      render :new, status: :unprocessable_content
    end
  end

  private
    def set_prescription
      @prescription = Prescription.find(params[:prescription_id])
    end

    def require_own_prescription
      redirect_to root_path, alert: "Grrrrr!" unless @prescription.user.id == Current.user.id
    end

    def require_active_prescription
      redirect_back fallback_location: root_path, notice: "This requires an active prescription" unless @prescription.active?
    end

    def pack_params
      params.expect(pack: [ :amount, :aquired_at ])
    end
end
