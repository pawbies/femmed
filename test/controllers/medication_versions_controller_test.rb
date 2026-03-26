require "test_helper"

class MedicationVersionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @medication         = medications(:ritalin_ir)
    @medication_version = medication_versions(:ritalin_ir_10mg)
    @user               = users(:alice)
    @admin              = users(:admin)
  end

  test "new" do
    # Not authenticated
    get new_medication_medication_version_url(@medication)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get new_medication_medication_version_url(@medication)
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get new_medication_medication_version_url(@medication)
    assert_response :success
  end

  test "create" do
    # Not authenticated
    post medication_medication_versions_url(@medication), params: { medication_version: { added_name: "15mg" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    post medication_medication_versions_url(@medication), params: { medication_version: { added_name: "15mg" } }
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    assert_difference "MedicationVersion.count", 1 do
      post medication_medication_versions_url(@medication), params: {
        medication_version: {
          added_name: "15mg",
          medication_version_ingredients_attributes: []
        }
      }
    end
    assert_redirected_to medication_url(@medication)

    # Admin with invalid params
    assert_no_difference "MedicationVersion.count" do
      post medication_medication_versions_url(@medication), params: {
        medication_version: { added_name: "" }
      }
    end
    assert_response :unprocessable_content
  end

  test "edit" do
    # Not authenticated
    get edit_medication_version_url(@medication_version)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get edit_medication_version_url(@medication_version)
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get edit_medication_version_url(@medication_version)
    assert_response :success
  end

  test "update" do
    # Not authenticated
    patch medication_version_url(@medication_version), params: { medication_version: { added_name: "Updated" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    patch medication_version_url(@medication_version), params: { medication_version: { added_name: "Updated" } }
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    patch medication_version_url(@medication_version), params: { medication_version: { added_name: "Updated 10mg" } }
    assert_redirected_to medication_url(@medication_version.medication)

    # Admin with invalid params
    patch medication_version_url(@medication_version), params: { medication_version: { added_name: "" } }
    assert_response :unprocessable_content
  end

  test "destroy" do
    # Not authenticated
    delete medication_version_url(@medication_version)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    delete medication_version_url(@medication_version)
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    version = MedicationVersion.create!(medication: @medication, added_name: "99mg")
    assert_difference "MedicationVersion.count", -1 do
      delete medication_version_url(version)
    end
    assert_redirected_to medication_url(@medication)
  end
end
