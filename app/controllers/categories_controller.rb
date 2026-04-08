class CategoriesController < ApplicationController
  before_action :require_admin, except: :show
  before_action :set_category,  except: %i[ index new create ]

  def index
    @pagy, @categories = pagy(:offset, Category.order(:name))
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params

    if @category.save
      redirect_to @category
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  def edit
  end

  def update
    if @category.update category_params
      redirect_to @category
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @category.destroy!

    redirect_to root_path, notice: t(".is_no_more", name: @category.name)
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.expect(category: [ :name, medication_ids: [] ])
    end
end
