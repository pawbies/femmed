require "test_helper"

class ActiveIngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user  = users(:alice)
    @admin = users(:admin)
  end

  # new
  test "should redirect new if not authenticated" do
    get new_active_ingredient_path
    assert_redirected_to new_session_path
  end

  test "should redirect new if not admin" do
    sign_in_as(@user)
    get new_active_ingredient_path
    assert_redirected_to root_path
  end

  test "should get new if admin" do
    sign_in_as(@admin)
    get new_active_ingredient_path
    assert_response :success
  end

  # create
  test "should redirect create if not authenticated" do
    post active_ingredients_path, params: { active_ingredient: { name: "Test" } }
    assert_redirected_to new_session_path
  end

  test "should redirect create if not admin" do
    sign_in_as(@user)
    post active_ingredients_path, params: { active_ingredient: { name: "Test" } }
    assert_redirected_to root_path
  end

  test "should create active ingredient with valid params" do
    sign_in_as(@admin)
    assert_difference "ActiveIngredient.count", 1 do
      post active_ingredients_path, params: { active_ingredient: {
        name: "Methylphenidate :3",
        half_life: 3.5
      } }
    end
    assert_redirected_to search_path(query: "Methylphenidate :3")
  end

  test "should not create active ingredient with invalid params" do
    sign_in_as(@admin)
    assert_no_difference "ActiveIngredient.count" do
      post active_ingredients_path, params: { active_ingredient: {
        name: "",
        half_life: nil
      } }
    end
    assert_response :unprocessable_content
  end
end
