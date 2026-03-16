require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
  end

  test "index" do
    # Not authenticated
    get settings_url
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get settings_url
    assert_response :success
  end
end
