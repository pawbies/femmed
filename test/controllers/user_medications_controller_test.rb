require "test_helper"

class UserMedicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get user_medications_new_url
    assert_response :success
  end
end
