require "test_helper"

class BioMarkersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bio_marker = bio_markers(:one)
    @user  = users(:alice)
    @admin = users(:admin)
  end

  test "index" do
    # Not authenticated
    get bio_markers_url
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get bio_markers_url
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get bio_markers_url
    assert_response :success
  end

  test "show" do
    # Not authenticated
    get bio_marker_url(@bio_marker)
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get bio_marker_url(@bio_marker)
    assert_response :success
  end

  test "new" do
    # Not authenticated
    get new_bio_marker_url
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get new_bio_marker_url
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get new_bio_marker_url
    assert_response :success
  end

  test "create" do
    # Not authenticated
    post bio_markers_url, params: { bio_marker: { name: "Test" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    assert_no_difference "BioMarker.count" do
      post bio_markers_url, params: { bio_marker: { name: "Test" } }
    end
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    assert_difference "BioMarker.count" do
      post bio_markers_url, params: { bio_marker: { name: "Cholesterol", abbreviation: "CHOL", unit: "mg/dL" } }
    end
    assert_redirected_to bio_marker_url(BioMarker.last)

    # Admin with invalid params
    assert_no_difference "BioMarker.count" do
      post bio_markers_url, params: { bio_marker: { name: "" } }
    end
    assert_response :unprocessable_content
  end

  test "edit" do
    # Not authenticated
    get edit_bio_marker_url(@bio_marker)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get edit_bio_marker_url(@bio_marker)
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get edit_bio_marker_url(@bio_marker)
    assert_response :success
  end

  test "update" do
    # Not authenticated
    patch bio_marker_url(@bio_marker), params: { bio_marker: { name: "Updated" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    patch bio_marker_url(@bio_marker), params: { bio_marker: { name: "Updated" } }
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    patch bio_marker_url(@bio_marker), params: { bio_marker: { name: "Updated Glucose", abbreviation: "GLU2" } }
    assert_redirected_to bio_marker_url(@bio_marker)
    assert_equal "Updated Glucose", @bio_marker.reload.name

    # Admin with invalid params
    patch bio_marker_url(@bio_marker), params: { bio_marker: { name: "" } }
    assert_response :unprocessable_content
  end

  test "destroy" do
    # Not authenticated
    delete bio_marker_url(@bio_marker)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    assert_no_difference "BioMarker.count" do
      delete bio_marker_url(@bio_marker)
    end
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    assert_difference "BioMarker.count", -1 do
      delete bio_marker_url(@bio_marker)
    end
    assert_redirected_to bio_markers_url
  end
end
