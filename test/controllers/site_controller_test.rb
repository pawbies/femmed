require "test_helper"

class SiteControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @admin = users(:admin)
  end

  # index
  test "should redirect index if not authenticated" do
    get root_url
    assert_redirected_to landing_url
  end

  test "should get index if authenticated" do
    sign_in_as(@user)
    get root_url
    assert_response :success
  end

  # landing
  test "should get landing if not authenticated" do
    get landing_url
    assert_response :success
  end

  test "should get landing if authenticated" do
    sign_in_as(@user)
    get landing_url
    assert_response :success
  end

  # about
  test "should get about if not authenticated" do
    get about_url
    assert_response :success
  end

  test "should get about if authenticated" do
    sign_in_as(@user)
    get about_url
    assert_response :success
  end

  # timeline
  test "should get timeline unless unauthenticated" do
    get timeline_url
    assert_redirected_to new_session_url
  end

  test "should get timeline if authenticated" do
    sign_in_as(@user)
    get timeline_url
    assert_response :success
  end

  test "timline should default to today when no date given" do
    sign_in_as(@user)
    get timeline_url
    assert_equal Date.today, assigns(:date)
  end

  test "timline should parse a valid date param" do
    sign_in_as(@user)
    get timeline_url, params: { date: "2026-01-15" }
    assert_equal Date.new(2026, 1, 15), assigns(:date)
  end

  test "timline should fallback to today for an invalid date param" do
    sign_in_as(@user)
    get timeline_url, params: { date: "not-a-date" }
    assert_equal Date.today, assigns(:date)
  end

  test "timeline should redirect to today if date is in the future" do
    sign_in_as(@user)
    get timeline_url, params: { date: Date.tomorrow.iso8601 }
    assert_redirected_to timeline_url(date: Date.today)
  end

  # calendar
  test "should get calendar if authenticated" do
    sign_in_as(@user)
    get calendar_url
    assert_response :success
  end

  test "calendar should get redirected if not authenticated" do
    get calendar_url
    assert_redirected_to new_session_url
  end


  test "calendar should get month mode if authenticated" do
    sign_in_as(@user)
    get calendar_url(mode: "month")
    assert_response :success
  end

  test "calendar should get week mode if authenticated" do
    sign_in_as(@user)
    get calendar_url(mode: "week")
    assert_response :success
  end

  # admin
  test "should get redirect from admin if unauthenticated" do
    get admin_url
    assert_redirected_to new_session_url
  end

  test "should get redirect from admin if not admin" do
    sign_in_as @user
    get admin_url
    assert_redirected_to root_url
  end

  test "should get admin if admin" do
    sign_in_as @admin
    get admin_url
    assert_response :success
  end
end
