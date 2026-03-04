require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:stimulants)
    @user     = users(:alice)
    @admin    = users(:admin)
  end

  # show
  test "should redirect show if not authenticated" do
    get category_url(@category)
    assert_redirected_to new_session_url
  end

  test "should get show if authenticated" do
    sign_in_as(@user)
    get category_url(@category)
    assert_response :success
  end

  # new
  test "should redirect new if not authenticated" do
    get new_category_url
    assert_redirected_to new_session_url
  end

  test "should redirect new if not admin" do
    sign_in_as(@user)
    get new_category_url
    assert_redirected_to root_url
  end

  test "should get new if admin" do
    sign_in_as(@admin)
    get new_category_url
    assert_response :success
  end

  # create
  test "should redirect create if not authenticated" do
    post categories_url, params: { category: { name: "Test" } }
    assert_redirected_to new_session_url
  end

  test "should redirect create if not admin" do
    sign_in_as(@user)
    assert_no_difference "Category.count" do
      post categories_url, params: { category: { name: "Test" } }
    end
    assert_redirected_to root_url
  end

  test "should create category if admin" do
    sign_in_as(@admin)
    assert_difference "Category.count" do
      post categories_url, params: { category: { name: "New Category" } }
    end
    assert_redirected_to category_url(Category.last)
  end

  test "should not create category with invalid params" do
    sign_in_as(@admin)
    assert_no_difference "Category.count" do
      post categories_url, params: { category: { name: "" } }
    end
    assert_response :unprocessable_content
  end

  # edit
  test "should redirect edit if not authenticated" do
    get edit_category_url(@category)
    assert_redirected_to new_session_url
  end

  test "should redirect edit if not admin" do
    sign_in_as(@user)
    get edit_category_url(@category)
    assert_redirected_to root_url
  end

  test "should get edit if admin" do
    sign_in_as(@admin)
    get edit_category_url(@category)
    assert_response :success
  end

  # update
  test "should redirect update if not authenticated" do
    patch category_url(@category), params: { category: { name: "Updated" } }
    assert_redirected_to new_session_url
  end

  test "should redirect update if not admin" do
    sign_in_as(@user)
    patch category_url(@category), params: { category: { name: "Updated" } }
    assert_redirected_to root_url
  end

  test "should update category if admin" do
    sign_in_as(@admin)
    patch category_url(@category), params: { category: { name: "Updated" } }
    assert_redirected_to category_url(@category)
    assert_equal "Updated", @category.reload.name
  end

  test "should not update category with invalid params" do
    sign_in_as(@admin)
    patch category_url(@category), params: { category: { name: "" } }
    assert_response :unprocessable_content
  end

  # destroy
  test "should redirect destroy if not authenticated" do
    delete category_url(@category)
    assert_redirected_to new_session_url
  end

  test "should redirect destroy if not admin" do
    sign_in_as(@user)
    assert_no_difference "Category.count" do
      delete category_url(@category)
    end
    assert_redirected_to root_url
  end

  test "should destroy category if admin" do
    sign_in_as(@admin)
    assert_difference "Category.count", -1 do
      delete category_url(@category)
    end
    assert_redirected_to root_url
  end
end
