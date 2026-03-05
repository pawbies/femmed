require "test_helper"

class DosesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user         = users(:alice)
    @other_user   = users(:bob)
    @prescription = prescriptions(:alice_ritalin_ir)
    @dose         = doses(:alice_ritalin_ir_dose_1)
  end

  # new
  test "should redirect new if not authenticated" do
    get new_prescription_dose_url(@prescription)
    assert_redirected_to new_session_url
  end

  test "should redirect new if prescription belongs to another user" do
    sign_in_as(@other_user)
    get new_prescription_dose_url(@prescription)
    assert_redirected_to root_url
  end

  test "should get new if own prescription" do
    sign_in_as(@user)
    get new_prescription_dose_url(@prescription)
    assert_response :success
  end

  test "should redirect new if inactive prescription" do
    sign_in_as(@user)
    @prescription.update! active: false
    get new_prescription_dose_url(@prescription)
    assert_redirected_to root_url
  end

  # create
  test "should redirect create if not authenticated" do
    post prescription_doses_url(@prescription), params: { dose: { amount_taken: 1, taken_at: Time.current } }
    assert_redirected_to new_session_url
  end

  test "should redirect create if prescription belongs to another user" do
    sign_in_as(@other_user)
    post prescription_doses_url(@prescription), params: { dose: { amount_taken: 1, taken_at: Time.current } }
    assert_redirected_to root_url
  end

  test "should create dose with valid params" do
    sign_in_as(@user)
    assert_difference "Dose.count", 1 do
      post prescription_doses_url(@prescription), params: { dose: {
        amount_taken: 1,
        taken_at: Time.current.change(sec: 0)
      } }
    end
    assert_redirected_to @prescription
  end

  test "should not create dose with invalid params" do
    sign_in_as(@user)
    assert_no_difference "Dose.count" do
      post prescription_doses_url(@prescription), params: { dose: {
        amount_taken: nil,
        taken_at: nil
      } }
    end
    assert_response :unprocessable_content
  end

  test "should redirect create if inactive prescription" do
    sign_in_as(@user)
    @prescription.update! active: false
    assert_no_difference "Dose.count" do
      post prescription_doses_url(@prescription), params: { dose: {
        amount_taken: 1,
        taken_at: Time.current.change(sec: 0)
      } }
    end
    assert_redirected_to root_url
  end

  # edit
  test "should redirect edit if not authenticated" do
    get edit_prescription_dose_url(@prescription, @dose)
    assert_redirected_to new_session_url
  end

  test "should redirect edit if prescription belongs to another user" do
    sign_in_as(@other_user)
    get edit_prescription_dose_url(@prescription, @dose)
    assert_redirected_to root_url
  end

  test "should get edit if own prescription" do
    sign_in_as(@user)
    get edit_prescription_dose_url(@prescription, @dose)
    assert_response :success
  end

  test "should redirect edit if inactive prescription" do
    sign_in_as(@user)
    @prescription.update! active: false
    get edit_prescription_dose_url(@prescription, @dose)
    assert_redirected_to root_url
  end

  # update
  test "should redirect update if not authenticated" do
    patch prescription_dose_url(@prescription, @dose), params: { dose: { amount_taken: 2 } }
    assert_redirected_to new_session_url
  end

  test "should redirect update for another user" do
    sign_in_as(@other_user)
    patch prescription_dose_url(@prescription, @dose), params: { dose: { amount_taken: 2 } }
    assert_redirected_to root_url
  end

  test "should update medication with valid params" do
    sign_in_as(@user)
    patch prescription_dose_url(@prescription, @dose), params: { dose: { amount_taken: 2 } }
    assert_redirected_to prescription_url(@prescription)
  end

  test "should not update medication with invalid params" do
    sign_in_as(@user)
    patch prescription_dose_url(@prescription, @dose), params: { dose: { amount_taken: -2 } }
    assert_response :unprocessable_content
  end

  test "should redirect update if inactive prescription" do
    sign_in_as(@user)
    @prescription.update! active: false
    patch prescription_dose_url(@prescription, @dose), params: { dose: { amount_taken: 2 } }
    assert_redirected_to root_url
  end

  # destroy
  test "should redirect destroy if not authenticated" do
    delete prescription_dose_url(@prescription, @dose)
    assert_redirected_to new_session_url
  end

  test "should destroy own prescription" do
    sign_in_as(@user)
    assert_difference("Dose.count", -1) do
      delete prescription_dose_url(@prescription, @dose)
    end
  end

  test "should not destroy another user's dose" do
    sign_in_as(@other_user)
    assert_no_difference("Dose.count") do
      delete prescription_dose_url(@prescription, @dose)
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy if inactive prescription" do
    sign_in_as(@user)
    @prescription.update! active: false
    assert_no_difference("Prescription.count") do
      delete prescription_dose_url(@prescription, @dose)
    end
    assert_redirected_to root_url
  end
end
