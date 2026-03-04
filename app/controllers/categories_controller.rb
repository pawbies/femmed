class CategoriesController < ApplicationController
  before_action :set_category,  except: %i[new create]
  before_action :require_admin, except: :show

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params

    if @category.save
      redirect_to @category, notice: "Created the super duper cute #{@category.name} category"
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
      redirect_to @category, notice: "All done boss ^^"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @category.destroy!

    redirect_to root_path, notice: "#{@category.name} is no more"
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, medication_ids: [])
    end
end
