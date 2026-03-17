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
      @prescriptions      = Current.user.prescriptions.joins(medication_version: :medication)
                                   .where(
                                     "LOWER(medication_versions.added_name) LIKE LOWER(:q) OR LOWER(medications.name) LIKE LOWER(:q)",
                                     q: "%#{sanitized_query}%"
                                   ).order(created_at: :desc)
      @active_ingredients = ActiveIngredient.where("LOWER(name) LIKE LOWER(?)", "%#{sanitized_query}%").order(:name)
      @categories         = Category.where("LOWER(name) LIKE LOWER(?)",         "%#{sanitized_query}%").order(:name)
      @labelers           = Labeler.where("LOWER(name) LIKE LOWER(?)",          "%#{sanitized_query}%").order(:name)
    else
      @prescriptions      = []
      @active_ingredients = ActiveIngredient.all
      @categories         = Category.all
      @labelers           = Labeler.all
    end

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end
end
