require "test_helper"

class Pages::CalendarControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
  end

  test "show" do
    # unauthenticated
    get calendar_url
    assert_redirected_to new_session_url

    # authenticated
    sign_in_as(@user)
    get calendar_url
    assert_response :success
  end
end
