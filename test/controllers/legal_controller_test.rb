require "test_helper"

class LegalControllerTest < ActionDispatch::IntegrationTest
  test "should get imprint" do
    get imprint_url
    assert_response :success
  end

  test "should get terms_of_service" do
    get terms_of_service_url
    assert_response :success
  end

  test "should get privacy" do
    get privacy_url
    assert_response :success
  end
end
