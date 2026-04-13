class BioMarkersController < ApplicationController
  before_action :require_admin, except: :show
  before_action :set_bio_marker, except: %i[ index ]

  def index
    @pagy, @bio_markers = pagy(:offset, BioMarker.order(:name))
  end

  def show
  end

  private
    def set_bio_marker
      @bio_marker = BioMarker.find(params[:id])
    end
end
