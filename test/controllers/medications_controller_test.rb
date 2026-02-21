require "test_helper"

class MedicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get show unless not authenticated" do
    get medication_path(1)
    assert_redirected_to new_session_path
  end
end
