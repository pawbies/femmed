require "test_helper"

class DiaryEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user        = users(:alice)
    @diary_entry = diary_entries(:alice_morning_thoughts)
  end

  test "index" do
    get user_diary_entries_url(@user)
    assert_redirected_to new_session_url

    sign_in_as @user
    get user_diary_entries_url(@user)
    assert_response :success
  end

  test "new" do
    get new_user_diary_entry_url(@user)
    assert_redirected_to new_session_url

    sign_in_as @user
    get new_user_diary_entry_url(@user)
    assert_response :success

    [
      { hour: 3, text: "Night" },
      { hour: 9, text: "Morning" },
      { hour: 12, text: "Midday" },
      { hour: 16, text: "Afternoon" },
      { hour: 19, text: "Evening" },
      { hour: 23, text: "Night" }
    ].each do |testcase|
      travel_to Time.zone.local(2026, 1, 1, testcase[:hour], 0, 0)
        get new_user_diary_entry_url(@user)
        assert_match testcase[:text], response.body
    end
  end
end
