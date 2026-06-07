require "test_helper"

class Prescriptions::GraphControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user               = users(:alice)
    @other_user         = users(:bob)
    @prescription       = prescriptions(:alice_percocet)
    @other_prescription = prescriptions(:bob_adderall_xr)
  end

  test "show: redirects when not authenticated" do
    get prescription_graph_url(@prescription)
    assert_redirected_to new_session_url
  end

  test "show: 404 for another user's prescription" do
    sign_in_as(@user)
    get prescription_graph_url(@other_prescription)
    assert_response :not_found
  end

  test "show: success for own prescription" do
    sign_in_as(@user)
    get prescription_graph_url(@prescription)
    assert_response :success
  end

  test "show: accepts custom past and future time ranges" do
    sign_in_as(@user)
    get prescription_graph_url(@prescription, past: 168, future: 48)
    assert_response :success
  end

  test "show: clamps out-of-range hours" do
    sign_in_as(@user)
    get prescription_graph_url(@prescription, past: 999999, future: -5)
    assert_response :success
  end
end
