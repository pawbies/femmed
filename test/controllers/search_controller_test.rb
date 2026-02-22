require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
  end

  # Unauthenticated
  test "should redirect search if not authenticated" do
    get search_url
    assert_redirected_to new_session_path
  end

  # Authenticated
  test "should get search if authenticated" do
    sign_in_as(@user)
    get search_url
    assert_response :success
  end

  test "should find medication by name" do
    sign_in_as(@user)
    get search_url, params: { query: "ritalin" }
    assert_response :success
    assert_includes @controller.instance_variable_get(:@medications), medications(:ritalin_ir)
  end

  test "should find active ingredient by name" do
    sign_in_as(@user)
    get search_url, params: { query: "methylphenidate" }
    assert_response :success
    assert_includes @controller.instance_variable_get(:@active_ingredients), active_ingredients(:methylphenidate)
  end

  test "should find category by name" do
    sign_in_as(@user)
    get search_url, params: { query: "stimulant" }
    assert_response :success
    assert_includes @controller.instance_variable_get(:@categories), categories(:stimulants)
  end

  test "should find labeler by name" do
    sign_in_as(@user)
    get search_url, params: { query: "pfizer" }
    assert_response :success
    assert_includes @controller.instance_variable_get(:@labelers), labelers(:pfizer)
  end

  test "should return empty results for unknown query" do
    sign_in_as(@user)
    get search_url, params: { query: "zzznomatch" }
    assert_response :success
    assert_empty @controller.instance_variable_get(:@medications)
    assert_empty @controller.instance_variable_get(:@active_ingredients)
    assert_empty @controller.instance_variable_get(:@categories)
    assert_empty @controller.instance_variable_get(:@labelers)
  end
end
