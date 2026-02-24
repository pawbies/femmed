require "test_helper"

class PacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @other_user = users(:bob)
    @prescription = prescriptions(:alice_ritalin_ir)
    @other_prescription = prescriptions(:bob_wellbutrin)
    @pack = packs(:alice_ritalin_ir_pack)
  end

  # new
  test "should redirect new if not authenticated" do
    get new_prescription_pack_url(@prescription)
    assert_redirected_to new_session_path
  end

  test "should get new if authenticated" do
    sign_in_as(@user)
    get new_prescription_pack_url(@prescription)
    assert_response :success
  end

  test "should not get new for another user's prescription" do
    sign_in_as(@other_user)
    get new_prescription_pack_url(@prescription)
    assert_redirected_to root_path
  end

  # create
  test "should redirect create if not authenticated" do
    post prescription_packs_url(@prescription), params: { pack: { amount: 30, aquired_at: Date.today } }
    assert_redirected_to new_session_path
  end

  test "should create pack if authenticated" do
    sign_in_as(@user)
    assert_difference("Pack.count") do
      post prescription_packs_url(@prescription), params: { pack: { amount: 30, aquired_at: Date.today } }
    end
    assert_redirected_to prescription_path(@prescription, page: "Packs")
  end

  test "should not create pack for another user's prescription" do
    sign_in_as(@other_user)
    assert_no_difference("Pack.count") do
      post prescription_packs_url(@prescription), params: { pack: { amount: 30, aquired_at: Date.today } }
    end
    assert_redirected_to root_path
  end

  test "should not create pack with missing amount" do
    sign_in_as(@user)
    assert_no_difference("Pack.count") do
      post prescription_packs_url(@prescription), params: { pack: { amount: nil, aquired_at: Date.today } }
    end
    assert_response :unprocessable_content
  end

  test "should not create pack with non-integer amount" do
    sign_in_as(@user)
    assert_no_difference("Pack.count") do
      post prescription_packs_url(@prescription), params: { pack: { amount: "abc", aquired_at: Date.today } }
    end
    assert_response :unprocessable_content
  end

  test "should not create pack with future date" do
    sign_in_as(@user)
    assert_no_difference("Pack.count") do
      post prescription_packs_url(@prescription), params: { pack: { amount: 30, aquired_at: Date.tomorrow } }
    end
    assert_response :unprocessable_content
  end

  test "should not create pack with missing aquired_at" do
    sign_in_as(@user)
    assert_no_difference("Pack.count") do
      post prescription_packs_url(@prescription), params: { pack: { amount: 30, aquired_at: nil } }
    end
    assert_response :unprocessable_content
  end

  test "should create pack with today's date" do
    sign_in_as(@user)
    assert_difference("Pack.count") do
      post prescription_packs_url(@prescription), params: { pack: { amount: 30, aquired_at: Date.today } }
    end
    assert_equal Pack.last.aquired_at, Date.today
  end

  test "should create pack with past date" do
    sign_in_as(@user)
    past_date = 5.days.ago.to_date
    assert_difference("Pack.count") do
      post prescription_packs_url(@prescription), params: { pack: { amount: 30, aquired_at: past_date } }
    end
    assert_equal Pack.last.aquired_at, past_date
  end

  test "should render new template on validation error" do
    sign_in_as(@user)
    post prescription_packs_url(@prescription), params: { pack: { amount: nil, aquired_at: Date.today } }
    assert_response :unprocessable_content
  end
end
