require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @other_user = users(:bob)
    @admin = users(:admin)
  end

  test "index" do
    # Not authenticated
    get users_url
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get users_url
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get users_url
    assert_response :success
  end

  test "new" do
    sign_in_as(@admin)
    get new_user_url
    assert_template layout: "application"
  end

  test "create" do
    sign_in_as(@admin)
    assert_difference("User.count", 1) do
      post users_url, params: { user: { email_address: "new@example.com", username: "newuser", password: "password", password_confirmation: "password", terms_of_service: "1" } }
    end
    assert_redirected_to User.last
  end

  test "show" do
    # Not authenticated
    get user_url(@user)
    assert_redirected_to new_session_url

    # Own profile
    sign_in_as(@user)
    get user_url(@user)
    assert_response :success

    # Another user's profile
    sign_in_as(@other_user)
    get user_url(@user)
    assert_redirected_to root_url

    # Admin viewing any user
    sign_in_as(@admin)
    get user_url(@user)
    assert_response :success
  end

  test "edit" do
    # Not authenticated
    get edit_user_url(@user)
    assert_redirected_to new_session_url

    # Own profile
    sign_in_as(@user)
    get edit_user_url(@user)
    assert_response :success

    # Another user's profile
    sign_in_as(@other_user)
    get edit_user_url(@user)
    assert_redirected_to root_url
  end

  test "update" do
    # Not authenticated
    patch user_url(@user), params: { user: { username: "newname" } }
    assert_redirected_to new_session_url

    # Own profile
    sign_in_as(@user)
    patch user_url(@user), params: { user: { username: "updatedname" } }
    assert_redirected_to @user

    # Another user's profile
    sign_in_as(@other_user)
    patch user_url(@user), params: { user: { username: "hacked" } }
    assert_redirected_to root_url

    # Admin updating any user
    sign_in_as(@admin)
    patch user_url(@user), params: { user: { username: "adminupdated" } }
    assert_redirected_to @user
  end

  test "destroy" do
    # Not authenticated
    delete user_url(@user)
    assert_redirected_to new_session_url

    # Own account
    sign_in_as(@user)
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end
    assert_redirected_to landing_url

    # Another user's account
    sign_in_as(@other_user)
    assert_no_difference("User.count") do
      delete user_url(@user)
    end
    assert_redirected_to root_url

    # Admin destroying any user
    sign_in_as(@admin)
    assert_difference("User.count", -1) do
      delete user_url(@other_user)
    end
    assert_redirected_to users_url
  end
end
