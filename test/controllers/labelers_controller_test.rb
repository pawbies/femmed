require "test_helper"

class LabelersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user  = users(:alice)
    @admin = users(:admin)
  end

  # new
  test "should redirect new if not authenticated" do
    get new_labeler_path
    assert_redirected_to new_session_path
  end

  test "should redirect new if not admin" do
    sign_in_as(@user)
    get new_labeler_path
    assert_redirected_to root_path
  end

  test "should get new if admin" do
    sign_in_as(@admin)
    get new_labeler_path
    assert_response :success
  end

  # create
  test "should redirect create if not authenticated" do
    post labelers_path, params: { labeler: { name: "Test" } }
    assert_redirected_to new_session_path
  end

  test "should redirect create if not admin" do
    sign_in_as(@user)
    post labelers_path, params: { labeler: { name: "Test" } }
    assert_redirected_to root_path
  end

  test "should create labeler with valid params" do
    sign_in_as(@admin)
    assert_difference "Labeler.count", 1 do
      post labelers_path, params: { labeler: { name: "Pfizer 2" } }
    end
    assert_redirected_to search_path(query: "Pfizer 2")
  end

  test "should not create labeler with invalid params" do
    sign_in_as(@admin)
    assert_no_difference "Labeler.count" do
      post labelers_path, params: { labeler: { name: "" } }
    end
    assert_response :unprocessable_content
  end
end
