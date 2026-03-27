class FormsController < ApplicationController
  before_action :require_admin
  before_action :set_form, except: %i[ index new create ]

  def index
    @pagy, @forms = pagy(:offset, Form.order(:name))
  end

  def new
    @form = Form.new
  end

  def create
    @form = Form.new form_params

    if @form.save
      redirect_to @form
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  def edit
  end

  def update
    if @form.update form_params
      redirect_to @form
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @form.destroy!
    redirect_to root_path, notice: "Got rid of #{@form.name}"
  rescue ActiveRecord::InvalidForeignKey
    redirect_to @form, notice: "This form still has medications"
  end

  private
    def form_params
      params.expect(form: [ :name ])
    end

    def set_form
      @form = Form.find(params[:id])
    end
end
