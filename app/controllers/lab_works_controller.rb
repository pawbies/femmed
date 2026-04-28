class LabWorksController < ApplicationController
  before_action :set_lab_work, except: %i[ index new create ]

  def index
    @lab_works = Current.user.lab_works
  end

  def new
    @lab_work = Current.user.lab_works.new(taken_at: Time.current.change(sec: 0))
  end

  def create
    @lab_work = Current.user.lab_works.new lab_work_create_params

    if @lab_work.save
      redirect_to @lab_work
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  def destroy
    @lab_work.destroy!

    redirect_to lab_works_url
  end

  private
    def lab_work_create_params
      params.expect(lab_work: [ :taken_at ])
    end

    def set_lab_work
      @lab_work = Current.user.lab_works.includes(results: :bio_marker).find(params[:id])
    end
end
