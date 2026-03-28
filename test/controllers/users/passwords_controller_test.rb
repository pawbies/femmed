require "test_helper"

class Users::PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @other_user = users(:bob)
  end

  test "edit redirects when not authenticated" do
    get edit_user_password_url(@user)
    assert_redirected_to new_session_url
  end

  test "edit redirects when authenticated as another user" do
    sign_in_as(@other_user)
    get edit_user_password_url(@user)
    assert_redirected_to root_url
  end

  test "edit renders for own user" do
    sign_in_as(@user)
    get edit_user_password_url(@user)
    assert_response :success
  end

  test "update redirects when not authenticated" do
    patch user_password_url(@user), params: { old_password: "password", password: "newpassword", password_confirmation: "newpassword" }
    assert_redirected_to new_session_url
  end

  test "update redirects when authenticated as another user" do
    sign_in_as(@other_user)
    patch user_password_url(@user), params: { old_password: "password", password: "newpassword", password_confirmation: "newpassword" }
    assert_redirected_to root_url
  end

  test "update succeeds with correct old password" do
    sign_in_as(@user)
    patch user_password_url(@user), params: { old_password: "password", password: "newpassword", password_confirmation: "newpassword" }
    assert_redirected_to @user
  end

  test "update fails with wrong old password" do
    sign_in_as(@user)
    patch user_password_url(@user), params: { old_password: "wrongpassword", password: "newpassword", password_confirmation: "newpassword" }
    assert_redirected_to edit_user_password_url(@user)
  end

  test "update fails when new passwords do not match" do
    sign_in_as(@user)
    patch user_password_url(@user), params: { old_password: "password", password: "newpassword", password_confirmation: "different" }
    assert_redirected_to edit_user_password_url(@user)
  end
end
