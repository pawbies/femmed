require "test_helper"

class DosesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user         = users(:alice)
    @other_user   = users(:bob)
    @prescription = prescriptions(:alice_ritalin_ir)
  end

  # new
  test "should redirect new if not authenticated" do
    get new_prescription_dose_path(@prescription)
    assert_redirected_to new_session_path
  end

  test "should redirect new if prescription belongs to another user" do
    sign_in_as(@other_user)
    get new_prescription_dose_path(@prescription)
    assert_redirected_to root_path
  end

  test "should get new if own prescription" do
    sign_in_as(@user)
    get new_prescription_dose_path(@prescription)
    assert_response :success
  end

  # create
  test "should redirect create if not authenticated" do
    post prescription_doses_path(@prescription), params: { dose: { amount_taken: 1, taken_at: Time.current } }
    assert_redirected_to new_session_path
  end

  test "should redirect create if prescription belongs to another user" do
    sign_in_as(@other_user)
    post prescription_doses_path(@prescription), params: { dose: { amount_taken: 1, taken_at: Time.current } }
    assert_redirected_to root_path
  end

  test "should create dose with valid params" do
    sign_in_as(@user)
    assert_difference "Dose.count", 1 do
      post prescription_doses_path(@prescription), params: { dose: {
        amount_taken: 1,
        taken_at: Time.current.change(sec: 0)
      } }
    end
    assert_redirected_to @prescription
  end

  test "should not create dose with invalid params" do
    sign_in_as(@user)
    assert_no_difference "Dose.count" do
      post prescription_doses_path(@prescription), params: { dose: {
        amount_taken: nil,
        taken_at: nil
      } }
    end
    assert_response :unprocessable_content
  end
end
