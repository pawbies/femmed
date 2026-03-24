require "test_helper"

class Pages::LandingControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    get landing_url
    assert_response :success
  end
end
