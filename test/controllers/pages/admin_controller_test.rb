require "test_helper"

class Pages::AdminControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @admin = users(:admin)
  end

  test "show" do
    # unauthenticated
    get admin_url
    assert_redirected_to new_session_url

    # authenticated
    sign_in_as(@user)
    get admin_url
    assert_redirected_to root_url

    # admin
    sign_in_as(@admin)
    get admin_url
    assert_response :success
  end
end
