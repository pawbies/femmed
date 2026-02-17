require "test_helper"

class SiteControllerTest < ActionDispatch::IntegrationTest
  test "should get index unless unauthenticated" do
    get root_url
    assert_redirected_to landing_url
  end
end
