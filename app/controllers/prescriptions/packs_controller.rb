class Prescriptions::PacksController < Prescriptions::BaseController
  before_action :require_active_prescription, except: :index
  before_action :set_pack, except: %i[ index new create ]
  before_action :require_pack_tracking_enabled

  def index
    @pagy, @packs = pagy(:offset, @prescription.packs.order(acquired_at: :desc), limit: 10)
  end

  def new
    last_amount = @prescription.packs.last.amount unless @prescription.packs.empty?
    @pack = @prescription.packs.new(acquired_at: Date.today, amount: last_amount)
  end

  def create
    @pack = @prescription.packs.new pack_params

    if @pack.save
      redirect_to prescription_packs_path(@prescription)
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @pack.update pack_params
      redirect_to prescription_packs_path(@prescription)
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @pack.destroy!
    redirect_to prescription_packs_path(@prescription)
  end

  private
    def set_pack
      @pack = @prescription.packs.find(params[:id])
    end

    def require_pack_tracking_enabled
      redirect_back fallback_location: root_path, notice: t(".requires_pack_tracking") unless @prescription.pack_tracking_enabled?
    end

    def pack_params
      params.expect(prescription_pack: [ :amount, :acquired_at ])
    end
end
