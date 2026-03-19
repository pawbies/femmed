class ActiveIngredientsController < ApplicationController
  before_action :require_admin, except: :show
  before_action :set_active_ingredient, except: %i[ new create ]

  def new
    @active_ingredient = ActiveIngredient.new
  end

  def create
    @active_ingredient = ActiveIngredient.new active_ingredient_params

    if @active_ingredient.save
      redirect_to @active_ingredient
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  def edit
  end

  def update
    if @active_ingredient.update active_ingredient_params
      redirect_to @active_ingredient
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @active_ingredient.destroy!

    redirect_to root_path, notice: "Poor #{@active_ingredient.name} is gone now"
  end

  private
    def active_ingredient_params
      params.expect(active_ingredient: [ :name, :half_life, :absorption_rate, :volume_of_distribution ])
    end

    def set_active_ingredient
      @active_ingredient = ActiveIngredient.find(params[:id])
    end
end
