class SearchController < ApplicationController
  def index
    @query = params[:query].strip

    @active_ingredients = ActiveIngredient.where("LOWER(name) LIKE LOWER(?)", "%#{@query}%").order(:name)
    @categories         = Category.where("LOWER(name) LIKE LOWER(?)",         "%#{@query}%").order(:name)
    @labelers           = Labeler.where("LOWER(name) LIKE LOWER(?)",          "%#{@query}%").order(:name)
    @medications        = Medication.where("LOWER(name) LIKE LOWER(?)",       "%#{@query}%").order(:name)
  end
end
