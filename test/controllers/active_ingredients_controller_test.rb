require "test_helper"

class ActiveIngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @active_ingredient = active_ingredients(:amphetamine)
    @user  = users(:alice)
    @admin = users(:admin)
  end

  # show
  test "should redirect show if not authenticated" do
    get active_ingredient_url(@active_ingredient)
    assert_redirected_to new_session_url
  end

  test "should get show if authenticated" do
    sign_in_as(@user)
    get active_ingredient_url(@active_ingredient)
    assert_response :success
  end

  # new
  test "should redirect new if not authenticated" do
    get new_active_ingredient_url
    assert_redirected_to new_session_url
  end

  test "should redirect new if not admin" do
    sign_in_as(@user)
    get new_active_ingredient_url
    assert_redirected_to root_url
  end

  test "should get new if admin" do
    sign_in_as(@admin)
    get new_active_ingredient_url
    assert_response :success
  end

  # create
  test "should redirect create if not authenticated" do
    post active_ingredients_url, params: { active_ingredient: { name: "Test" } }
    assert_redirected_to new_session_url
  end

  test "should redirect create if not admin" do
    sign_in_as(@user)
    assert_no_difference "ActiveIngredient.count" do
      post active_ingredients_url, params: { active_ingredient: { name: "Test" } }
    end
    assert_redirected_to root_url
  end

  test "should create active ingredient with valid params" do
    sign_in_as(@admin)
    assert_difference "ActiveIngredient.count" do
      post active_ingredients_url, params: { active_ingredient: { name: "Methylphenidate :3", half_life: 3.5 } }
    end
    assert_redirected_to search_url(query: "Methylphenidate :3")
  end

  test "should not create active ingredient with invalid params" do
    sign_in_as(@admin)
    assert_no_difference "ActiveIngredient.count" do
      post active_ingredients_url, params: { active_ingredient: { name: "", half_life: nil } }
    end
    assert_response :unprocessable_content
  end

  # edit
  test "should redirect edit if not authenticated" do
    get edit_active_ingredient_url(@active_ingredient)
    assert_redirected_to new_session_url
  end

  test "should redirect edit if not admin" do
    sign_in_as(@user)
    get edit_active_ingredient_url(@active_ingredient)
    assert_redirected_to root_url
  end

  test "should get edit if admin" do
    sign_in_as(@admin)
    get edit_active_ingredient_url(@active_ingredient)
    assert_response :success
  end

  # update
  test "should redirect update if not authenticated" do
    patch active_ingredient_url(@active_ingredient), params: { active_ingredient: { name: "Updated" } }
    assert_redirected_to new_session_url
  end

  test "should redirect update if not admin" do
    sign_in_as(@user)
    patch active_ingredient_url(@active_ingredient), params: { active_ingredient: { name: "Updated" } }
    assert_redirected_to root_url
  end

  test "should update active ingredient if admin" do
    sign_in_as(@admin)
    patch active_ingredient_url(@active_ingredient), params: { active_ingredient: { name: "Updated", half_life: 5.0 } }
    assert_redirected_to active_ingredient_url(@active_ingredient)
    assert_equal "Updated", @active_ingredient.reload.name
  end

  test "should not update active ingredient with invalid params" do
    sign_in_as(@admin)
    patch active_ingredient_url(@active_ingredient), params: { active_ingredient: { name: "" } }
    assert_response :unprocessable_content
  end

  # destroy
  test "should redirect destroy if not authenticated" do
    delete active_ingredient_url(@active_ingredient)
    assert_redirected_to new_session_url
  end

  test "should redirect destroy if not admin" do
    sign_in_as(@user)
    assert_no_difference "ActiveIngredient.count" do
      delete active_ingredient_url(@active_ingredient)
    end
    assert_redirected_to root_url
  end

  test "should destroy active ingredient if admin" do
    sign_in_as(@admin)
    assert_difference "ActiveIngredient.count", -1 do
      delete active_ingredient_url(@active_ingredient)
    end
    assert_redirected_to root_url
  end
end
