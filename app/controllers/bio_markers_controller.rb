class BioMarkersController < ApplicationController
  before_action :require_admin, except: :show
  before_action :set_bio_marker, except: %i[ index new create ]

  def index
    @pagy, @bio_markers = pagy(:offset, BioMarker.order(:name))
  end

  def new
    @bio_marker = BioMarker.new
  end

  def create
    @bio_marker = BioMarker.new bio_marker_params

    if @bio_marker.save
      redirect_to @bio_marker
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @bio_marker.update bio_marker_params
      redirect_to @bio_marker
    else
      render :edit, status: :unprocessable_content
    end
  end

  def show
  end

  def destroy
    @bio_marker.destroy!

    redirect_to bio_markers_path, notice: t(".deleted", name: @bio_marker.name)
  end

  private
    def set_bio_marker
      @bio_marker = BioMarker.find(params[:id])
    end

    def bio_marker_params
      params.expect(bio_marker: [
        :name,
        :abbreviation,
        :description,
        :min_reference_value,
        :max_reference_value,
        :unit
      ])
    end
end
