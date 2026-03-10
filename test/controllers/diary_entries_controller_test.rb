require "test_helper"

class DiaryEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user        = users(:alice)
    @other_user  = users(:bob)
    @diary_entry = diary_entries(:alice_morning_thoughts)
  end

  test "index" do
    get user_diary_entries_url(@user)
    assert_redirected_to new_session_url

    sign_in_as @user
    get user_diary_entries_url(@user)
    assert_response :success
  end

  test "cannot view another user's diary entries" do
    sign_in_as @other_user
    get user_diary_entries_url(@user)
    assert_redirected_to root_path
  end

  test "new" do
    get new_user_diary_entry_url(@user)
    assert_redirected_to new_session_url

    sign_in_as @user
    get new_user_diary_entry_url(@user)
    assert_response :success

    [
      { hour: 3,  text: "Night" },
      { hour: 9,  text: "Morning" },
      { hour: 12, text: "Midday" },
      { hour: 16, text: "Afternoon" },
      { hour: 19, text: "Evening" },
      { hour: 23, text: "Night" }
    ].each do |testcase|
      travel_to Time.zone.local(2026, 1, 1, testcase[:hour], 0, 0) do
        get new_user_diary_entry_url(@user)
        assert_match testcase[:text], response.body
      end
    end
  end

  test "create" do
    get new_user_diary_entry_url(@user)
    assert_redirected_to new_session_url

    sign_in_as @user
    assert_difference "@user.diary_entries.count" do
      post user_diary_entries_url(@user), params: {
        diary_entry: { title: "Test entry", body: "Hello", entry_for: DateTime.current }
      }
    end
    assert_redirected_to user_diary_entry_url(@user, @user.diary_entries.last)
  end

  test "create with invalid params renders new" do
    sign_in_as @user
    assert_no_difference "@user.diary_entries.count" do
      post user_diary_entries_url(@user), params: {
        diary_entry: { title: "", body: "", entry_for: nil }
      }
    end
    assert_response :unprocessable_content
  end

  test "show" do
    get user_diary_entry_url(@user, @diary_entry)
    assert_redirected_to new_session_url

    sign_in_as @user
    get user_diary_entry_url(@user, @diary_entry)
    assert_response :success
  end

  test "cannot view another user's diary entry" do
    sign_in_as @other_user
    get user_diary_entry_url(@user, @diary_entry)
    assert_redirected_to root_path
  end

  test "edit" do
    get edit_user_diary_entry_url(@user, @diary_entry)
    assert_redirected_to new_session_url

    sign_in_as @user
    get edit_user_diary_entry_url(@user, @diary_entry)
    assert_response :success
  end

  test "update" do
    patch user_diary_entry_url(@user, @diary_entry)
    assert_redirected_to new_session_url

    sign_in_as @user
    patch user_diary_entry_url(@user, @diary_entry), params: {
      diary_entry: { title: "Updated title" }
    }
    assert_redirected_to user_diary_entry_url(@user, @diary_entry)
    assert_equal "Updated title", @diary_entry.reload.title
  end

  test "update with invalid params renders edit" do
    sign_in_as @user
    patch user_diary_entry_url(@user, @diary_entry), params: {
      diary_entry: { title: "", entry_for: nil }
    }
    assert_response :unprocessable_content
  end

  test "destroy" do
    delete user_diary_entry_url(@user, @diary_entry)
    assert_redirected_to new_session_url

    sign_in_as @user
    assert_difference "@user.diary_entries.count", -1 do
      delete user_diary_entry_url(@user, @diary_entry)
    end
    assert_redirected_to user_diary_entries_url(@user)
  end

  test "cannot destroy another user's diary entry" do
    sign_in_as @other_user
    assert_no_difference "DiaryEntry.count" do
      delete user_diary_entry_url(@user, @diary_entry)
    end
    assert_redirected_to root_path
  end
end
