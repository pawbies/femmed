class LabWorks::ResultsController < ApplicationController
  before_action :set_lab_work

  def new
    @result = @lab_work.results.new
    @bio_markers = BioMarker.order(:name)
  end

  def create
    @result = @lab_work.results.new result_params

    if @result.save
      redirect_to @lab_work
    else
      @bio_markers = BioMarker.order(:name)
      render :new, status: :unprocessable_content
    end
  end

  private
    def set_lab_work
      @lab_work = Current.user.lab_works.find(params[:lab_work_id])
    end

    def result_params
      params.expect(lab_work_result: [ :bio_marker_id, :value ])
    end
end
