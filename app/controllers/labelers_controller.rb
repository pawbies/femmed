class LabelersController < ApplicationController
  before_action :require_admin

  def new
    @labeler = Labeler.new
  end

  def create
    @labeler = Labeler.new labeler_params

    if @labeler.save
      redirect_to search_path(query: @labeler.name), notice: "Created #{@labeler.name}"
    else
      render :new, status: :unprocessable_content
    end
  end

  private
    def labeler_params
      params.expect(labeler: [ :name ])
    end
end
