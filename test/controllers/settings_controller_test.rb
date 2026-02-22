require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
  end

  test "should redirect index if not authenticated" do
    get settings_url
    assert_redirected_to new_session_path
  end

  test "should get index if authenticated" do
    sign_in_as(@user)
    get settings_url
    assert_response :success
  end
end
