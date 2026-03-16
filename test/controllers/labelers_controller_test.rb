require "test_helper"

class LabelersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @labeler = labelers(:teva)
    @user    = users(:alice)
    @admin   = users(:admin)
  end

  test "show" do
    # Not authenticated
    get labeler_url(@labeler)
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get labeler_url(@labeler)
    assert_response :success
  end

  test "new" do
    # Not authenticated
    get new_labeler_url
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get new_labeler_url
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get new_labeler_url
    assert_response :success
  end

  test "create" do
    # Not authenticated
    post labelers_url, params: { labeler: { name: "Test" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    assert_no_difference "Labeler.count" do
      post labelers_url, params: { labeler: { name: "Test" } }
    end
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    assert_difference "Labeler.count" do
      post labelers_url, params: { labeler: { name: "Pfizer 2" } }
    end
    assert_redirected_to search_url(query: "Pfizer 2")

    # Admin with invalid params
    assert_no_difference "Labeler.count" do
      post labelers_url, params: { labeler: { name: "" } }
    end
    assert_response :unprocessable_content
  end

  test "edit" do
    # Not authenticated
    get edit_labeler_url(@labeler)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get edit_labeler_url(@labeler)
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get edit_labeler_url(@labeler)
    assert_response :success
  end

  test "update" do
    # Not authenticated
    patch labeler_url(@labeler), params: { labeler: { name: "Updated" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    patch labeler_url(@labeler), params: { labeler: { name: "Updated" } }
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    patch labeler_url(@labeler), params: { labeler: { name: "Updated" } }
    assert_redirected_to labeler_url(@labeler)
    assert_equal "Updated", @labeler.reload.name

    # Admin with invalid params
    patch labeler_url(@labeler), params: { labeler: { name: "" } }
    assert_response :unprocessable_content
  end

  test "destroy" do
    # Not authenticated
    delete labeler_url(@labeler)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    assert_no_difference "Labeler.count" do
      delete labeler_url(@labeler)
    end
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    assert_difference "Labeler.count", -1 do
      delete labeler_url(@labeler)
    end
    assert_redirected_to root_url
  end
end
