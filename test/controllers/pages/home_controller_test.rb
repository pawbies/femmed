require "test_helper"

class Pages::HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
  end

  test "show" do
    # unauthenticated
    get root_url
    assert_redirected_to landing_url

    # authenticated
    sign_in_as(@user)
    get root_url
    assert_response :success
  end
end
