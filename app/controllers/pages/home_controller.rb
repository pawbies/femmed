class Pages::HomeController < Pages::BaseController
  allow_unauthenticated_access
  before_action :redirect_to_landing_unless_authenticated

  def show
    @prescriptions = Current.user.prescriptions.includes(
      { medication_version: { medication_version_ingredients: :active_ingredient } },
      { medication: [ :release_profile, :medication_release_profile, :active_ingredients ] },
      :recent_doses
    ).order(active: :desc)

    @concentrations = PkCalculator.current_concentrations(@prescriptions)
  end

  private
    def redirect_to_landing_unless_authenticated
      redirect_to landing_path unless authenticated?
    end
end
