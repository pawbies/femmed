require "test_helper"

class TimelineControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
  end


  test "should get index unless unauthenticated" do
    get timeline_url
    assert_redirected_to new_session_url
  end

  test "should get index if authenticated" do
    sign_in_as(@user)
    get timeline_url
    assert_response :success
  end
end
