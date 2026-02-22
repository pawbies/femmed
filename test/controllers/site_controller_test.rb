require "test_helper"

class SiteControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
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
end
