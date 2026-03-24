require "test_helper"

class Pages::AboutControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    get about_url
    assert_response :success
  end
end
