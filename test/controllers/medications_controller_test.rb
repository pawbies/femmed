require "test_helper"

class MedicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @immediate_release = release_profiles(:immediate)
    @medication = medications(:ritalin_ir)
    @user       = users(:alice)
    @admin      = users(:admin)
  end

  # show
  test "should redirect show if not authenticated" do
    get medication_url(@medication)
    assert_redirected_to new_session_url
  end

  test "should get show if authenticated" do
    sign_in_as(@user)
    get medication_url(@medication)
    assert_response :success
  end

  # new
  test "should redirect new if not authenticated" do
    get new_medication_url
    assert_redirected_to new_session_url
  end

  test "should redirect new if not admin" do
    sign_in_as(@user)
    get new_medication_url
    assert_redirected_to root_url
  end

  test "should get new if admin" do
    sign_in_as(@admin)
    get new_medication_url
    assert_response :success
  end

  # create
  test "should redirect create if not authenticated" do
    post medications_url, params: { medication: { name: "Test" } }
    assert_redirected_to new_session_url
  end

  test "should redirect create if not admin" do
    sign_in_as(@user)
    post medications_url, params: { medication: { name: "Test" } }
    assert_redirected_to root_url
  end

  test "should create medication with valid params" do
    sign_in_as(@admin)
    assert_difference "Medication.count", 1 do
      post medications_url, params: { medication: {
        name: "Adderall",
        form_id: @medication.form_id,
        labeler_id: @medication.labeler_id,
        notes: "Take with food",
        medication_release_profile_attributes: { release_profile_id: @immediate_release.id },
        active_ingredient_ids: [],
        category_ids: []
      } }
    end
    assert_redirected_to medication_url(Medication.last)
  end

  test "should not create medication with invalid params" do
    sign_in_as(@admin)
    assert_no_difference "Medication.count" do
      post medications_url, params: { medication: {
        name: "",
        form_id: nil,
        labeler_id: nil,
        notes: "",
        active_ingredient_ids: [],
        category_ids: []
      } }
    end
    assert_response :unprocessable_content
  end

  # edit
  test "should redirect edit if not authenticated" do
    get edit_medication_url(@medication)
    assert_redirected_to new_session_url
  end

  test "should redirect edit if not admin" do
    sign_in_as(@user)
    get edit_medication_url(@medication)
    assert_redirected_to root_url
  end

  test "should get edit if admin" do
    sign_in_as(@admin)
    get edit_medication_url(@medication)
    assert_response :success
  end

  # update
  test "should redirect update if not authenticated" do
    patch medication_url(@medication), params: { medication: { name: "Updated" } }
    assert_redirected_to new_session_url
  end

  test "should redirect update if not admin" do
    sign_in_as(@user)
    patch medication_url(@medication), params: { medication: { name: "Updated" } }
    assert_redirected_to root_url
  end

  test "should update medication with valid params" do
    sign_in_as(@admin)
    patch medication_url(@medication), params: { medication: { name: "Updated Ritalin" } }
    assert_redirected_to medication_url(@medication)
  end

  test "should not update medication with invalid params" do
    sign_in_as(@admin)
    patch medication_url(@medication), params: { medication: { name: "" } }
    assert_response :unprocessable_content
  end

  # destroy
  test "should redirect destroy if not authenticated" do
    delete medication_url(@medication)
    assert_redirected_to new_session_url
  end

  test "should redirect destroy if not admin" do
    sign_in_as(@user)
    delete medication_url(@medication)
    assert_redirected_to root_url
  end

  test "should destroy medication if admin" do
    sign_in_as(@admin)
    assert_difference "Medication.count", -1 do
      delete medication_url(@medication)
    end
    assert_redirected_to root_url
  end
end
