require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
  end

  test "search" do
    # Not authenticated
    get search_url
    assert_redirected_to new_session_url

    # Authenticated without query
    sign_in_as(@user)
    get search_url
    assert_response :success

    # Find medication by name
    get search_url, params: { query: "ritalin" }
    assert_response :success
    assert_includes @controller.instance_variable_get(:@medications), medications(:ritalin_ir)

    # Find active ingredient by name
    get search_url, params: { query: "methylphenidate" }
    assert_response :success
    assert_includes @controller.instance_variable_get(:@active_ingredients), active_ingredients(:methylphenidate)

    # Find category by name
    get search_url, params: { query: "stimulant" }
    assert_response :success
    assert_includes @controller.instance_variable_get(:@categories), categories(:stimulants)

    # Find labeler by name
    get search_url, params: { query: "pfizer" }
    assert_response :success
    assert_includes @controller.instance_variable_get(:@labelers), labelers(:pfizer)

    # Unknown query returns empty results
    get search_url, params: { query: "zzznomatch" }
    assert_response :success
    assert_empty @controller.instance_variable_get(:@medications)
    assert_empty @controller.instance_variable_get(:@active_ingredients)
    assert_empty @controller.instance_variable_get(:@categories)
    assert_empty @controller.instance_variable_get(:@labelers)
  end
end
