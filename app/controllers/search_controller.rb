class SearchController < ApplicationController
  def index
    @query = params[:query]

    @active_ingredients = ActiveIngredient.where("LOWER(name) LIKE LOWER(?)", "%#{@query}%")
    @categories = Category.where("LOWER(name) LIKE LOWER(?)", "%#{@query}%")
    @labelers = Labeler.where("LOWER(name) LIKE LOWER(?)", "%#{@query}%")
    @medications = Medication.where("LOWER(name) LIKE LOWER(?)", "%#{@query}%")
  end
end
