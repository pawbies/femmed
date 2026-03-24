class Pages::AdminController < Pages::BaseController
  before_action :require_admin

  def show
  end
end
