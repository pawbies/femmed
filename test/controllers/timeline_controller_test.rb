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

  test "should default to today when no date given" do
    sign_in_as(@user)
    get timeline_url
    assert_equal Date.today, assigns(:date)
  end

  test "should parse a valid date param" do
    sign_in_as(@user)
    get timeline_url, params: { date: "2026-01-15" }
    assert_equal Date.new(2026, 1, 15), assigns(:date)
  end

  test "should fallback to today for an invalid date param" do
    sign_in_as(@user)
    get timeline_url, params: { date: "not-a-date" }
    assert_equal Date.today, assigns(:date)
  end

  test "should redirect to today if date is in the future" do
    sign_in_as(@user)
    get timeline_url, params: { date: Date.tomorrow.iso8601 }
    assert_redirected_to timeline_path(date: Date.today)
  end
end
