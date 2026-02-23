require "test_helper"

class UserMedicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @other_user = users(:bob)
    @medication_version = medication_versions(:ritalin_ir_10mg)
    @user_medication = user_medications(:alice_ritalin_ir)
  end

  # new
  test "should redirect new if not authenticated" do
    get new_medication_version_user_medication_url(@medication_version)
    assert_redirected_to new_session_path
  end

  test "should get new if authenticated" do
    sign_in_as(@user)
    get new_medication_version_user_medication_url(@medication_version)
    assert_response :success
  end

  # create
  test "should redirect create if not authenticated" do
    post medication_version_user_medications_url(@medication_version), params: { user_medication: { dosage: 10 } }
    assert_redirected_to new_session_path
  end

  test "should create user_medication if authenticated" do
    sign_in_as(@user)
    assert_difference("UserMedication.count") do
      post medication_version_user_medications_url(@medication_version), params: { user_medication: { user_id: @user.id, dosage: 10 } }
    end
    assert_redirected_to medication_path(@medication_version.medication)
  end

  test "should not create user_medication for another user" do
    sign_in_as(@other_user)
    post medication_version_user_medications_url(@medication_version), params: { user_medication: { user_id: @user.id, dosage: 10 } }
    assert_response :forbidden
  end

  # show
  test "should redirect show if not authenticated" do
    get user_medication_url(@user_medication)
    assert_redirected_to new_session_path
  end

  test "should get show if authenticated and it's own medication" do
    sign_in_as(@user)
    get user_medication_url(@user_medication)
    assert_response :success
  end

  test "should not get show for another user's medication" do
    sign_in_as(@other_user)
    get user_medication_url(@user_medication)
    assert_redirected_to root_path
  end

  # destroy
  test "should redirect destroy if not authenticated" do
    delete user_medication_url(@user_medication)
    assert_redirected_to new_session_path
  end

  test "should destroy own user_medication" do
    sign_in_as(@user)
    assert_difference("UserMedication.count", -1) do
      delete user_medication_url(@user_medication)
    end
  end

  test "should not destroy another user's user_medication" do
    sign_in_as(@other_user)
    assert_no_difference("UserMedication.count") do
      delete user_medication_url(@user_medication)
    end
    assert_redirected_to root_path
  end
end
