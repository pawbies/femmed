class ActiveIngredientsController < ApplicationController
  before_action :require_admin

  def new
    @active_ingredient = ActiveIngredient.new
  end

  def create
    @active_ingredient = ActiveIngredient.new active_ingredient_params

    if @active_ingredient.save
      redirect_to search_path(query: @active_ingredient.name), notice: "Created #{@active_ingredient.name}"
    else
      render :new, status: :unprocessable_content
    end
  end

  private
    def active_ingredient_params
      params.expect(active_ingredient: [ :name, :half_life ])
    end
end
