require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search unless unauthenticated" do
    get search_url
    assert_redirected_to new_session_path
  end
end
