require "test_helper"

class ActiveIngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @active_ingredient = active_ingredients(:amphetamine)
    @user  = users(:alice)
    @admin = users(:admin)
  end

  test "show" do
    # Not authenticated
    get active_ingredient_url(@active_ingredient)
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get active_ingredient_url(@active_ingredient)
    assert_response :success
  end

  test "new" do
    # Not authenticated
    get new_active_ingredient_url
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get new_active_ingredient_url
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get new_active_ingredient_url
    assert_response :success
  end

  test "create" do
    # Not authenticated
    post active_ingredients_url, params: { active_ingredient: { name: "Test" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    assert_no_difference "ActiveIngredient.count" do
      post active_ingredients_url, params: { active_ingredient: { name: "Test" } }
    end
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    assert_difference "ActiveIngredient.count" do
      post active_ingredients_url, params: { active_ingredient: { name: "Methylphenidate :3", half_life: 3.5 } }
    end
    assert_redirected_to active_ingredient_url(ActiveIngredient.last)

    # Admin with invalid params
    assert_no_difference "ActiveIngredient.count" do
      post active_ingredients_url, params: { active_ingredient: { name: "", half_life: nil } }
    end
    assert_response :unprocessable_content
  end

  test "edit" do
    # Not authenticated
    get edit_active_ingredient_url(@active_ingredient)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get edit_active_ingredient_url(@active_ingredient)
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get edit_active_ingredient_url(@active_ingredient)
    assert_response :success
  end

  test "update" do
    # Not authenticated
    patch active_ingredient_url(@active_ingredient), params: { active_ingredient: { name: "Updated" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    patch active_ingredient_url(@active_ingredient), params: { active_ingredient: { name: "Updated" } }
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    patch active_ingredient_url(@active_ingredient), params: { active_ingredient: { name: "Updated", half_life: 5.0 } }
    assert_redirected_to active_ingredient_url(@active_ingredient)
    assert_equal "Updated", @active_ingredient.reload.name

    # Admin with invalid params
    patch active_ingredient_url(@active_ingredient), params: { active_ingredient: { name: "" } }
    assert_response :unprocessable_content
  end

  test "destroy" do
    # Not authenticated
    delete active_ingredient_url(@active_ingredient)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    assert_no_difference "ActiveIngredient.count" do
      delete active_ingredient_url(@active_ingredient)
    end
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    assert_difference "ActiveIngredient.count", -1 do
      delete active_ingredient_url(@active_ingredient)
    end
    assert_redirected_to root_url
  end
end
