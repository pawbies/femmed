class SearchController < ApplicationController
  def index
    @query      = params[:query]
    @category_id = params[:category_id]
    @labeler_id  = params[:labeler_id]


    @medications = Medication.all

    if @query.present?
      sanitized_query = ActiveRecord::Base.sanitize_sql_like(@query.strip)
      @medications = @medications.where("LOWER(name) LIKE LOWER(?)", "%#{sanitized_query}%")
    end

    @medications = @medications.joins(:categories).where(categories: { id: @category_id }) if @category_id.present?
    @medications = @medications.where(labeler_id: @labeler_id) if @labeler_id.present?
    @medications = @medications.order(:name)

    if @query.present?
      @active_ingredients = ActiveIngredient.where("LOWER(name) LIKE LOWER(?)", "%#{@query.strip}%").order(:name)
      @categories         = Category.where("LOWER(name) LIKE LOWER(?)",         "%#{@query.strip}%").order(:name)
      @labelers           = Labeler.where("LOWER(name) LIKE LOWER(?)",          "%#{@query.strip}%").order(:name)
    else
      @active_ingredients = ActiveIngredient.all
      @categories         = Category.all
      @labelers           = Labeler.all
    end
  end
end
