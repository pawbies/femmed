require "test_helper"

class PrescriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @other_user = users(:bob)
    @medication_version = medication_versions(:ritalin_ir_10mg)
    @other_medication_version = medication_versions(:ritalin_ir_5mg)
    @prescription = prescriptions(:alice_ritalin_ir)
  end

  test "create" do
    # Not authenticated
    post prescriptions_url(@medication_version)
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    assert_difference("Prescription.count") do
      post prescriptions_url(@user), params: { prescription: { medication_version_id: @other_medication_version.id } }
    end
    assert_redirected_to prescription_doses_path(Prescription.last)
  end

  test "edit" do
    # Not authenticated
    get edit_prescription_url(@prescription)
    assert_redirected_to new_session_url

    # Own prescription
    sign_in_as(@user)
    get edit_prescription_url(@prescription)
    assert_response :success

    # Another user's prescription
    sign_in_as(@other_user)
    get edit_prescription_url(@prescription)
    assert_response :not_found
  end

  test "update" do
    # Not authenticated
    patch prescription_url(@prescription), params: { prescription: { amount: 10 } }
    assert_redirected_to new_session_url

    # Own prescription
    sign_in_as(@user)
    patch prescription_url(@prescription), params: { prescription: { amount: 10 } }
    assert_redirected_to edit_prescription_path(@prescription)

    # Another user's prescription
    sign_in_as(@other_user)
    patch prescription_url(@prescription), params: { prescription: { amount: 10 } }
    assert_response :not_found
  end

  test "destroy" do
    # Not authenticated
    delete prescription_url(@prescription)
    assert_redirected_to new_session_url

    # Own prescription
    sign_in_as(@user)
    assert_difference("Prescription.count", -1) do
      delete prescription_url(@prescription)
    end

    # Another user's prescription
    sign_in_as(@other_user)
    assert_no_difference("Prescription.count") do
      delete prescription_url(@prescription)
    end
    assert_response :not_found
  end
end
