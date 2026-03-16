require "test_helper"

class MedicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @immediate_release = release_profiles(:immediate)
    @medication = medications(:ritalin_ir)
    @user       = users(:alice)
    @admin      = users(:admin)
  end

  test "show" do
    # Not authenticated
    get medication_url(@medication)
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get medication_url(@medication)
    assert_response :success
  end

  test "new" do
    # Not authenticated
    get new_medication_url
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get new_medication_url
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get new_medication_url
    assert_response :success
  end

  test "create" do
    # Not authenticated
    post medications_url, params: { medication: { name: "Test" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    post medications_url, params: { medication: { name: "Test" } }
    assert_redirected_to root_url

    # Admin with valid params
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

    # Admin with invalid params
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

  test "edit" do
    # Not authenticated
    get edit_medication_url(@medication)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get edit_medication_url(@medication)
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get edit_medication_url(@medication)
    assert_response :success
  end

  test "update" do
    # Not authenticated
    patch medication_url(@medication), params: { medication: { name: "Updated" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    patch medication_url(@medication), params: { medication: { name: "Updated" } }
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    patch medication_url(@medication), params: { medication: { name: "Updated Ritalin" } }
    assert_redirected_to medication_url(@medication)

    # Admin with invalid params
    patch medication_url(@medication), params: { medication: { name: "" } }
    assert_response :unprocessable_content
  end

  test "destroy" do
    # Not authenticated
    delete medication_url(@medication)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    delete medication_url(@medication)
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    assert_difference "Medication.count", -1 do
      delete medication_url(@medication)
    end
    assert_redirected_to root_url
  end
end
