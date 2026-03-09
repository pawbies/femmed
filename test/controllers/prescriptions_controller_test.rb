require "test_helper"

class PrescriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @other_user = users(:bob)
    @medication_version = medication_versions(:ritalin_ir_10mg)
    @other_medication_version = medication_versions(:ritalin_ir_5mg)
    @prescription = prescriptions(:alice_ritalin_ir)
  end

  # create
  test "should redirect create if not authenticated" do
    post user_prescriptions_url(@medication_version)
    assert_redirected_to new_session_url
  end

  test "should create prescription if authenticated" do
    sign_in_as(@user)
    assert_difference("Prescription.count") do
      post user_prescriptions_url(@user), params: { prescription: { medication_version_id: @other_medication_version.id } }
    end
    assert_redirected_to user_prescription_path(@user, Prescription.last)
  end

  # show
  test "should redirect show if not authenticated" do
    get user_prescription_url(@user, @prescription)
    assert_redirected_to new_session_url
  end

  test "should get show if authenticated and it's own medication" do
    sign_in_as(@user)
    get user_prescription_url(@user, @prescription)
    assert_response :success
  end

  test "should not get show for another user's medication" do
    sign_in_as(@other_user)
    get user_prescription_url(@user, @prescription)
    assert_redirected_to root_path
  end

  # destroy
  test "should redirect destroy if not authenticated" do
    delete user_prescription_url(@user, @prescription)
    assert_redirected_to new_session_url
  end

  test "should destroy own prescription" do
    sign_in_as(@user)
    assert_difference("Prescription.count", -1) do
      delete user_prescription_url(@user, @prescription)
    end
  end

  test "should not destroy another user's prescription" do
    sign_in_as(@other_user)
    assert_no_difference("Prescription.count") do
      delete user_prescription_url(@user, @prescription)
    end
    assert_redirected_to root_path
  end

  # update
  test "should redirect update if not authenticated" do
    patch user_prescription_url(@user, @prescription), params: { prescription: { amount: 10 } }
    assert_redirected_to new_session_url
  end

  test "should update prescription if authenticated" do
    sign_in_as(@user)
    patch user_prescription_url(@user, @prescription), params: { prescription: { amount: 10 } }
    assert_redirected_to user_prescription_url(@user, @prescription, page: "Settings")
  end

  test "should not update prescription for another user" do
    sign_in_as(@other_user)
    patch user_prescription_url(@user, @prescription), params: { prescription: { amount: 10 } }
    assert_redirected_to root_path
  end
end
