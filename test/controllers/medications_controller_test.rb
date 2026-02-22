require "test_helper"

class MedicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @medication = medications(:ritalin_ir)
    @user = users(:alice)
  end

  # Unauthenticated
  test "should redirect show if not authenticated" do
    get medication_path(@medication)
    assert_redirected_to new_session_path
  end

  # Authenticated
  test "should get show if authenticated" do
    sign_in_as(@user)
    get medication_path(@medication)
    assert_response :success
  end
end
