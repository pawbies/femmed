require "test_helper"

class Prescriptions::AboutControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user        = users(:alice)
    @other_user  = users(:bob)
    @prescription       = prescriptions(:alice_ritalin_ir)
    @other_prescription = prescriptions(:bob_adderall_xr)
  end

  test "show: redirects when not authenticated" do
    get prescription_about_url(@prescription)
    assert_redirected_to new_session_url
  end

  test "show: 404 for another user's prescription" do
    sign_in_as(@other_user)
    get prescription_about_url(@prescription)
    assert_response :not_found
  end

  test "show: success for own prescription" do
    sign_in_as(@user)
    get prescription_about_url(@prescription)
    assert_response :success
  end
end
