require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @admin = users(:admin)
  end

  test "should get redirect from index if unauthenticated" do
    get admin_url
    assert_redirected_to new_session_url
  end

  test "should get redirect from index if not admin" do
    sign_in_as @user
    get admin_url
    assert_redirected_to root_url
  end

  test "should get index if admin" do
    sign_in_as @admin
    get admin_url
    assert_response :success
  end
end
