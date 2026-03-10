require "test_helper"

class DiaryEntrySideEffectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user        = users(:alice)
    @other_user  = users(:bob)
    @diary_entry = diary_entries(:alice_morning_thoughts)
    @side_effect = side_effects(:headache)
    @dese        = diary_entry_side_effects(:alice_headache)
  end

  # --- create ---

  test "create requires authentication" do
    post user_diary_entry_diary_entry_side_effects_url(@user, @diary_entry), params: {
      diary_entry_side_effect: { side_effect_id: @side_effect.id, severity: "Mild" }
    }
    assert_redirected_to new_session_url
  end

  test "create with existing side effect" do
    sign_in_as @user
    assert_difference "@diary_entry.diary_entry_side_effects.count" do
      post user_diary_entry_diary_entry_side_effects_url(@user, @diary_entry), params: {
        diary_entry_side_effect: { side_effect_id: @side_effect.id, severity: "Mild" }
      }
    end
    assert_redirected_to user_diary_entry_url(@user, @diary_entry)
  end

  test "create with new side effect creates the side effect" do
    sign_in_as @user
    assert_difference "SideEffect.count" do
      assert_difference "@diary_entry.diary_entry_side_effects.count" do
        post user_diary_entry_diary_entry_side_effects_url(@user, @diary_entry), params: {
          diary_entry_side_effect: {
            side_effect_id: "new",
            severity: "Mild",
            side_effect_attributes: { name: "Brain fog" }
          }
        }
      end
    end
    assert_redirected_to user_diary_entry_url(@user, @diary_entry)
    # assert SideEffect.exists?(name: "Brain fog")
  end

  test "create with invalid params redirects with unprocessable content" do
    sign_in_as @user
    assert_no_difference "@diary_entry.diary_entry_side_effects.count" do
      post user_diary_entry_diary_entry_side_effects_url(@user, @diary_entry), params: {
        diary_entry_side_effect: { side_effect_id: nil, severity: nil }
      }
    end
    assert_response :unprocessable_content
  end

  test "cannot create side effect on another user's diary entry" do
    sign_in_as @other_user
    assert_no_difference "DiaryEntrySideEffect.count" do
      post user_diary_entry_diary_entry_side_effects_url(@user, @diary_entry), params: {
        diary_entry_side_effect: { side_effect_id: @side_effect.id, severity: "Mild" }
      }
    end
    assert_redirected_to root_path
  end

  # --- destroy ---

  test "destroy requires authentication" do
    delete user_diary_entry_diary_entry_side_effect_url(@user, @diary_entry, @dese)
    assert_redirected_to new_session_url
  end

  test "destroy removes the side effect" do
    sign_in_as @user
    assert_difference "@diary_entry.diary_entry_side_effects.count", -1 do
      delete user_diary_entry_diary_entry_side_effect_url(@user, @diary_entry, @dese)
    end
    assert_redirected_to user_diary_entry_url(@user, @diary_entry)
  end

  test "cannot destroy another user's side effect" do
    sign_in_as @other_user
    assert_no_difference "DiaryEntrySideEffect.count" do
      delete user_diary_entry_diary_entry_side_effect_url(@user, @diary_entry, @dese)
    end
    assert_redirected_to root_path
  end
end
