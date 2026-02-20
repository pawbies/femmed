require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search unless unauthenticated" do
    get search_index_url
    assert_redirected_to landing_url
  end
end
