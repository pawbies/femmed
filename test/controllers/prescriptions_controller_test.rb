require "test_helper"

class PrescriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @other_user = users(:bob)
    @medication_version = medication_versions(:ritalin_ir_10mg)
    @prescription = prescriptions(:alice_ritalin_ir)
  end

  # new
  test "should redirect new if not authenticated" do
    get new_medication_version_prescription_url(@medication_version)
    assert_redirected_to new_session_path
  end

  test "should get new if authenticated" do
    sign_in_as(@user)
    get new_medication_version_prescription_url(@medication_version)
    assert_response :success
  end

  # create
  test "should redirect create if not authenticated" do
    post medication_version_prescriptions_url(@medication_version), params: { prescription: { dosage: 10 } }
    assert_redirected_to new_session_path
  end

  test "should create prescription if authenticated" do
    sign_in_as(@user)
    assert_difference("Prescription.count") do
      post medication_version_prescriptions_url(@medication_version), params: { prescription: { user_id: @user.id, dosage: 10 } }
    end
    assert_redirected_to medication_path(@medication_version.medication)
  end

  test "should not create prescription for another user" do
    sign_in_as(@other_user)
    post medication_version_prescriptions_url(@medication_version), params: { prescription: { user_id: @user.id, dosage: 10 } }
    assert_response :forbidden
  end

  # show
  test "should redirect show if not authenticated" do
    get prescription_url(@prescription)
    assert_redirected_to new_session_path
  end

  test "should get show if authenticated and it's own medication" do
    sign_in_as(@user)
    get prescription_url(@prescription)
    assert_response :success
  end

  test "should not get show for another user's medication" do
    sign_in_as(@other_user)
    get prescription_url(@prescription)
    assert_redirected_to root_path
  end

  # destroy
  test "should redirect destroy if not authenticated" do
    delete prescription_url(@prescription)
    assert_redirected_to new_session_path
  end

  test "should destroy own prescription" do
    sign_in_as(@user)
    assert_difference("Prescription.count", -1) do
      delete prescription_url(@prescription)
    end
  end

  test "should not destroy another user's prescription" do
    sign_in_as(@other_user)
    assert_no_difference("Prescription.count") do
      delete prescription_url(@prescription)
    end
    assert_redirected_to root_path
  end
end
