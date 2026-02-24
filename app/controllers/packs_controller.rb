class PacksController < ApplicationController
  before_action :fetch_prescription_by_id
  before_action :require_own_prescription

  def new
    @pack = @prescription.packs.new
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
    def fetch_prescription_by_id
      @prescription = Prescription.find(params[:prescription_id])
    end

    def require_own_prescription
      redirect_to root_path, alert: "Grrrrr!" unless @prescription.user.id == Current.user.id
    end

    def pack_params
      params.expect(pack: [ :amount, :aquired_at ])
    end
end
