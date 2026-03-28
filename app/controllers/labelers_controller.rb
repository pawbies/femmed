class LabelersController < ApplicationController
  before_action :require_admin, except: :show
  before_action :set_labeler, except: %i[ index new create ]

  def index
    @pagy, @labelers = pagy(:offset, Labeler.order(:name))
  end

  def new
    @labeler = Labeler.new
  end

  def create
    @labeler = Labeler.new labeler_params

    if @labeler.save
      redirect_to @labeler
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  def edit
  end

  def update
    if @labeler.update labeler_params
      redirect_to @labeler
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @labeler.destroy!

    redirect_to root_path, notice: t(".gone_now")
  end

  private
    def labeler_params
      params.expect(labeler: [ :name ])
    end

    def set_labeler
      @labeler = Labeler.find(params[:id])
    end
end
