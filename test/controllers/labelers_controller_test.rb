require "test_helper"

class LabelersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @labeler = labelers(:teva)
    @user    = users(:alice)
    @admin   = users(:admin)
  end

  # show
  test "should redirect show if not authenticated" do
    get labeler_url(@labeler)
    assert_redirected_to new_session_url
  end

  test "should get show if authenticated" do
    sign_in_as(@user)
    get labeler_url(@labeler)
    assert_response :success
  end

  # new
  test "should redirect new if not authenticated" do
    get new_labeler_url
    assert_redirected_to new_session_url
  end

  test "should redirect new if not admin" do
    sign_in_as(@user)
    get new_labeler_url
    assert_redirected_to root_url
  end

  test "should get new if admin" do
    sign_in_as(@admin)
    get new_labeler_url
    assert_response :success
  end

  # create
  test "should redirect create if not authenticated" do
    post labelers_url, params: { labeler: { name: "Test" } }
    assert_redirected_to new_session_url
  end

  test "should redirect create if not admin" do
    sign_in_as(@user)
    assert_no_difference "Labeler.count" do
      post labelers_url, params: { labeler: { name: "Test" } }
    end
    assert_redirected_to root_url
  end

  test "should create labeler with valid params" do
    sign_in_as(@admin)
    assert_difference "Labeler.count" do
      post labelers_url, params: { labeler: { name: "Pfizer 2" } }
    end
    assert_redirected_to search_url(query: "Pfizer 2")
  end

  test "should not create labeler with invalid params" do
    sign_in_as(@admin)
    assert_no_difference "Labeler.count" do
      post labelers_url, params: { labeler: { name: "" } }
    end
    assert_response :unprocessable_content
  end

  # edit
  test "should redirect edit if not authenticated" do
    get edit_labeler_url(@labeler)
    assert_redirected_to new_session_url
  end

  test "should redirect edit if not admin" do
    sign_in_as(@user)
    get edit_labeler_url(@labeler)
    assert_redirected_to root_url
  end

  test "should get edit if admin" do
    sign_in_as(@admin)
    get edit_labeler_url(@labeler)
    assert_response :success
  end

  # update
  test "should redirect update if not authenticated" do
    patch labeler_url(@labeler), params: { labeler: { name: "Updated" } }
    assert_redirected_to new_session_url
  end

  test "should redirect update if not admin" do
    sign_in_as(@user)
    patch labeler_url(@labeler), params: { labeler: { name: "Updated" } }
    assert_redirected_to root_url
  end

  test "should update labeler if admin" do
    sign_in_as(@admin)
    patch labeler_url(@labeler), params: { labeler: { name: "Updated" } }
    assert_redirected_to labeler_url(@labeler)
    assert_equal "Updated", @labeler.reload.name
  end

  test "should not update labeler with invalid params" do
    sign_in_as(@admin)
    patch labeler_url(@labeler), params: { labeler: { name: "" } }
    assert_response :unprocessable_content
  end

  # destroy
  test "should redirect destroy if not authenticated" do
    delete labeler_url(@labeler)
    assert_redirected_to new_session_url
  end

  test "should redirect destroy if not admin" do
    sign_in_as(@user)
    assert_no_difference "Labeler.count" do
      delete labeler_url(@labeler)
    end
    assert_redirected_to root_url
  end

  test "should destroy labeler if admin" do
    sign_in_as(@admin)
    assert_difference "Labeler.count", -1 do
      delete labeler_url(@labeler)
    end
    assert_redirected_to root_url
  end
end
