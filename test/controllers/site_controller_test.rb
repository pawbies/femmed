require "test_helper"

class SiteControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @admin = users(:admin)
  end

  test "index" do
    # Not authenticated
    get root_url
    assert_redirected_to landing_url

    # Authenticated
    sign_in_as(@user)
    get root_url
    assert_response :success
  end

  test "landing" do
    # Not authenticated
    get landing_url
    assert_response :success

    # Authenticated
    sign_in_as(@user)
    get landing_url
    assert_response :success
  end

  test "about" do
    # Not authenticated
    get about_url
    assert_response :success

    # Authenticated
    sign_in_as(@user)
    get about_url
    assert_response :success
  end

  test "timeline" do
    # Not authenticated
    get timeline_url
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get timeline_url
    assert_response :success

    # Default to today when no date given
    get timeline_url
    assert_equal Date.today, assigns(:date)

    # Parse a valid date param
    get timeline_url, params: { date: "2026-01-15" }
    assert_equal Date.new(2026, 1, 15), assigns(:date)

    # Fallback to today for invalid date param
    get timeline_url, params: { date: "not-a-date" }
    assert_equal Date.today, assigns(:date)

    # Redirect to today if date is in the future
    get timeline_url, params: { date: Date.tomorrow.iso8601 }
    assert_redirected_to timeline_url(date: Date.today)
  end

  test "calendar" do
    # Not authenticated
    get calendar_url
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get calendar_url
    assert_response :success

    # Month mode
    get calendar_url(mode: "month")
    assert_response :success

    # Week mode
    get calendar_url(mode: "week")
    assert_response :success
  end

  test "admin" do
    # Not authenticated
    get admin_url
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as @user
    get admin_url
    assert_redirected_to root_url

    # Admin
    sign_in_as @admin
    get admin_url
    assert_response :success
  end
end
