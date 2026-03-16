class MedicationVersionsController < ApplicationController
  before_action :require_admin
  before_action :set_medication,         except: %i[ edit update destroy ]
  before_action :set_medication_version, only: %i[ edit update destroy ]

  def new
    @medication_version = @medication.versions.new
    @medication.active_ingredients.each do |active_ingredient|
      @medication_version.medication_version_ingredients.build(active_ingredient: active_ingredient)
    end
  end

  def create
    @medication_version = @medication.versions.new medication_version_params
    if @medication_version.save
      redirect_to @medication
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @medication_version.update medication_version_params
      redirect_to @medication_version.medication
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medication_version.destroy!

    redirect_to @medication_version.medication
  end

  private
    def medication_version_params
      params.require(:medication_version).permit(:added_name, medication_version_ingredients_attributes: [ :id, :active_ingredient_id, :amount, :unit ])
    end

    def set_medication
      @medication = Medication.find(params[:medication_id])
    end

    def set_medication_version
      @medication_version = MedicationVersion.find(params[:id])
    end
end
