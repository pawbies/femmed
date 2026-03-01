require "test_helper"

class CalendarControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
  end

  test "should get index if authenticated" do
    sign_in_as(@user)
    get calendar_url
    assert_response :success
  end

  test "should get redirected if not authenticated" do
    get calendar_url
    assert_redirected_to new_session_url
  end


  test "should get month mode if authenticated" do
    sign_in_as(@user)
    get calendar_url(mode: "month")
    assert_response :success
  end

  test "should get week mode if authenticated" do
    sign_in_as(@user)
    get calendar_url(mode: "week")
    assert_response :success
  end
end
