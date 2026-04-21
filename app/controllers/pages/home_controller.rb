class Pages::HomeController < Pages::BaseController
  allow_unauthenticated_access
  before_action :redirect_to_landing_unless_authenticated

  def show
    @prescriptions = Current.user.prescriptions.includes(
      { medication_version: { medication_version_ingredients: :active_ingredient } },
      { medication: [ :release_profile, :medication_release_profile, :active_ingredients ] },
      :recent_doses,
      :doses
    ).order(prescriptions: { active: :desc }, doses: { taken_at: :desc })

    @concentrations = PkCalculator.current_concentrations(@prescriptions)

    flash.now[:alert] = "uwu"
  end

  private
    def redirect_to_landing_unless_authenticated
      redirect_to landing_path unless authenticated?
    end
end
