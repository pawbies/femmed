require "test_helper"

class MedicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @medication = medications(:ritalin_ir)
    @user       = users(:alice)
    @admin      = users(:admin)
  end

  # show
  test "should redirect show if not authenticated" do
    get medication_path(@medication)
    assert_redirected_to new_session_path
  end

  test "should get show if authenticated" do
    sign_in_as(@user)
    get medication_path(@medication)
    assert_response :success
  end

  # new
  test "should redirect new if not authenticated" do
    get new_medication_path
    assert_redirected_to new_session_path
  end

  test "should redirect new if not admin" do
    sign_in_as(@user)
    get new_medication_path
    assert_redirected_to root_path
  end

  test "should get new if admin" do
    sign_in_as(@admin)
    get new_medication_path
    assert_response :success
  end

  # create
  test "should redirect create if not authenticated" do
    post medications_path, params: { medication: { name: "Test" } }
    assert_redirected_to new_session_path
  end

  test "should redirect create if not admin" do
    sign_in_as(@user)
    post medications_path, params: { medication: { name: "Test" } }
    assert_redirected_to root_path
  end

  test "should create medication with valid params" do
    sign_in_as(@admin)
    assert_difference "Medication.count", 1 do
      post medications_path, params: { medication: {
        name: "Adderall",
        form_id: @medication.form_id,
        labeler_id: @medication.labeler_id,
        notes: "Take with food",
        active_ingredient_ids: [],
        category_ids: []
      } }
    end
    assert_redirected_to medication_path(Medication.last)
  end

  test "should not create medication with invalid params" do
    sign_in_as(@admin)
    assert_no_difference "Medication.count" do
      post medications_path, params: { medication: {
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
end
