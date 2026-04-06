require "test_helper"

class Pages::DevelopmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
  end

  test "show" do
    # Unauthenticated
    get developments_url
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get developments_url
    assert_response :success
  end
end
