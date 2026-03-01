require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @other_user = users(:bob)
    @admin = users(:admin)
  end

  # new
  test "should get new if public" do
    get new_user_url
    assert_response :success
  end

  # create
  test "should create user if public" do
    assert_difference("User.count") do
      post users_url, params: { user: { email_address: "new@example.com", username: "newuser", password: "password", password_confirmation: "password", terms_of_service: "1" } }
    end
    assert_redirected_to root_path
  end

  test "should not create user with invalid params" do
    assert_no_difference("User.count") do
      post users_url, params: { user: { email_address: "", username: "", password: "password", password_confirmation: "wrong" } }
    end
    assert_response :unprocessable_content
  end

  # show
  test "should redirect show if not authenticated" do
    get user_url(@user)
    assert_redirected_to new_session_path
  end

  test "should get show for own profile" do
    sign_in_as(@user)
    get user_url(@user)
    assert_response :success
  end

  test "should not get show for another user" do
    sign_in_as(@other_user)
    get user_url(@user)
    assert_redirected_to root_path
  end

  test "should get show for any user as admin" do
    sign_in_as(@admin)
    get user_url(@user)
    assert_response :success
  end

  # edit
  test "should redirect edit if not authenticated" do
    get edit_user_url(@user)
    assert_redirected_to new_session_path
  end

  test "should get edit for own profile" do
    sign_in_as(@user)
    get edit_user_url(@user)
    assert_response :success
  end

  test "should not get edit for another user" do
    sign_in_as(@other_user)
    get edit_user_url(@user)
    assert_redirected_to root_path
  end

  # update
  test "should redirect update if not authenticated" do
    patch user_url(@user), params: { user: { username: "newname" } }
    assert_redirected_to new_session_path
  end

  test "should update own profile" do
    sign_in_as(@user)
    patch user_url(@user), params: { user: { username: "updatedname" } }
    assert_redirected_to @user
  end

  test "should not update another user's profile" do
    sign_in_as(@other_user)
    patch user_url(@user), params: { user: { username: "hacked" } }
    assert_redirected_to root_path
  end

  test "admin should update any user" do
    sign_in_as(@admin)
    patch user_url(@user), params: { user: { username: "adminupdated" } }
    assert_redirected_to @user
  end

  # destroy
  test "should redirect destroy if not authenticated" do
    delete user_url(@user)
    assert_redirected_to new_session_path
  end

  test "should destroy own account and redirect to landing" do
    sign_in_as(@user)
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end
    assert_redirected_to landing_path
  end

  test "should not destroy another user's account" do
    sign_in_as(@other_user)
    assert_no_difference("User.count") do
      delete user_url(@user)
    end
    assert_redirected_to root_path
  end

  test "admin should destroy any user and redirect to users" do
    sign_in_as(@admin)
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end
    assert_redirected_to users_path
  end
end
