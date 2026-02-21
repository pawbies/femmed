require "test_helper"

class MedicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get medications_show_url
    assert_response :success
  end
end
