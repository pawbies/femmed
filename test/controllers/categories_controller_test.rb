require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:stimulants)
    @user     = users(:alice)
    @admin    = users(:admin)
  end

  test "show" do
    # Not authenticated
    get category_url(@category)
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get category_url(@category)
    assert_response :success
  end

  test "new" do
    # Not authenticated
    get new_category_url
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get new_category_url
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get new_category_url
    assert_response :success
  end

  test "create" do
    # Not authenticated
    post categories_url, params: { category: { name: "Test" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    assert_no_difference "Category.count" do
      post categories_url, params: { category: { name: "Test" } }
    end
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    assert_difference "Category.count" do
      post categories_url, params: { category: { name: "New Category" } }
    end
    assert_redirected_to category_url(Category.last)

    # Admin with invalid params
    assert_no_difference "Category.count" do
      post categories_url, params: { category: { name: "" } }
    end
    assert_response :unprocessable_content
  end

  test "edit" do
    # Not authenticated
    get edit_category_url(@category)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get edit_category_url(@category)
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get edit_category_url(@category)
    assert_response :success
  end

  test "update" do
    # Not authenticated
    patch category_url(@category), params: { category: { name: "Updated" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    patch category_url(@category), params: { category: { name: "Updated" } }
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    patch category_url(@category), params: { category: { name: "Updated" } }
    assert_redirected_to category_url(@category)
    assert_equal "Updated", @category.reload.name

    # Admin with invalid params
    patch category_url(@category), params: { category: { name: "" } }
    assert_response :unprocessable_content
  end

  test "destroy" do
    # Not authenticated
    delete category_url(@category)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    assert_no_difference "Category.count" do
      delete category_url(@category)
    end
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    assert_difference "Category.count", -1 do
      delete category_url(@category)
    end
    assert_redirected_to root_url
  end
end
