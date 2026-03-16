require "test_helper"

class DosesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user         = users(:alice)
    @other_user   = users(:bob)
    @prescription = prescriptions(:alice_ritalin_ir)
    @dose         = doses(:alice_ritalin_ir_dose_1)
  end

  test "new" do
    # Not authenticated
    get new_prescription_dose_url(@prescription)
    assert_redirected_to new_session_url

    # Another user's prescription
    sign_in_as(@other_user)
    get new_prescription_dose_url(@prescription)
    assert_response :not_found

    # Own prescription
    sign_in_as(@user)
    get new_prescription_dose_url(@prescription)
    assert_response :success

    # Inactive prescription
    @prescription.update! active: false
    get new_prescription_dose_url(@prescription)
    assert_redirected_to root_url
  end

  test "create" do
    # Not authenticated
    post prescription_doses_url(@prescription), params: { dose: { amount_taken: 1, taken_at: Time.current } }
    assert_redirected_to new_session_url

    # Another user's prescription
    sign_in_as(@other_user)
    post prescription_doses_url(@prescription), params: { dose: { amount_taken: 1, taken_at: Time.current } }
    assert_response :not_found

    # Valid params
    sign_in_as(@user)
    assert_difference "Dose.count", 1 do
      post prescription_doses_url(@prescription), params: { dose: {
        amount_taken: 1,
        taken_at: Time.current.change(sec: 0)
      } }
    end
    assert_redirected_to prescription_path(@prescription)

    # Invalid params
    assert_no_difference "Dose.count" do
      post prescription_doses_url(@prescription), params: { dose: {
        amount_taken: nil,
        taken_at: nil
      } }
    end
    assert_response :unprocessable_content

    # Inactive prescription
    @prescription.update! active: false
    assert_no_difference "Dose.count" do
      post prescription_doses_url(@prescription), params: { dose: {
        amount_taken: 1,
        taken_at: Time.current.change(sec: 0)
      } }
    end
    assert_redirected_to root_url
  end

  test "edit" do
    # Not authenticated
    get edit_prescription_dose_url(@prescription, @dose)
    assert_redirected_to new_session_url

    # Another user's prescription
    sign_in_as(@other_user)
    get edit_prescription_dose_url(@prescription, @dose)
    assert_response :not_found

    # Own prescription
    sign_in_as(@user)
    get edit_prescription_dose_url(@prescription, @dose)
    assert_response :success

    # Inactive prescription
    @prescription.update! active: false
    get edit_prescription_dose_url(@prescription, @dose)
    assert_redirected_to root_url
  end

  test "update" do
    # Not authenticated
    patch prescription_dose_url(@prescription, @dose), params: { dose: { amount_taken: 2 } }
    assert_redirected_to new_session_url

    # Another user's prescription
    sign_in_as(@other_user)
    patch prescription_dose_url(@prescription, @dose), params: { dose: { amount_taken: 2 } }
    assert_response :not_found

    # Valid params
    sign_in_as(@user)
    patch prescription_dose_url(@prescription, @dose), params: { dose: { amount_taken: 2 } }
    assert_redirected_to prescription_url(@prescription)

    # Invalid params
    patch prescription_dose_url(@prescription, @dose), params: { dose: { amount_taken: -2 } }
    assert_response :unprocessable_content

    # Inactive prescription
    @prescription.update! active: false
    patch prescription_dose_url(@prescription, @dose), params: { dose: { amount_taken: 2 } }
    assert_redirected_to root_url
  end

  test "destroy" do
    # Not authenticated
    delete prescription_dose_url(@prescription, @dose)
    assert_redirected_to new_session_url

    # Own prescription
    sign_in_as(@user)
    assert_difference("Dose.count", -1) do
      delete prescription_dose_url(@prescription, @dose)
    end

    # Another user's dose
    sign_in_as(@other_user)
    assert_no_difference("Dose.count") do
      delete prescription_dose_url(@prescription, @dose)
    end
    assert_response :not_found

    # Inactive prescription
    sign_in_as(@user)
    @prescription.update! active: false
    assert_no_difference("Prescription.count") do
      delete prescription_dose_url(@prescription, @dose)
    end
    assert_redirected_to root_url
  end
end
