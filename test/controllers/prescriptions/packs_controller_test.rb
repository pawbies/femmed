require "test_helper"

class Prescriptions::PacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @other_user = users(:bob)
    @prescription = prescriptions(:alice_ritalin_ir)
    @other_prescription = prescriptions(:bob_adderall_xr)
    @pack = prescription_packs(:alice_ritalin_ir_pack)
  end

  test "new" do
    # Not authenticated
    get new_prescription_pack_url(@prescription)
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get new_prescription_pack_url(@prescription)
    assert_response :success

    # Inactive prescription
    @prescription.update! active: false
    get new_prescription_pack_url(@prescription)
    assert_redirected_to root_url

    # Another user's prescription
    @prescription.update! active: true
    sign_in_as(@other_user)
    get new_prescription_pack_url(@prescription)
    assert_response :not_found
  end

  test "create" do
    # Not authenticated
    post prescription_packs_url(@prescription), params: { prescription_pack: { amount: 30, acquired_at: Date.today } }
    assert_redirected_to new_session_url

    # Authenticated with valid params
    sign_in_as(@user)
    assert_difference("Prescription::Pack.count") do
      post prescription_packs_url(@prescription), params: { prescription_pack: { amount: 30, acquired_at: Date.today } }
    end
    assert_redirected_to prescription_packs_url(@prescription)
    assert_equal Prescription::Pack.last.acquired_at, Date.today

    # Another user's prescription
    sign_in_as(@other_user)
    assert_no_difference("Prescription::Pack.count") do
      post prescription_packs_url(@prescription), params: { prescription_pack: { amount: 30, acquired_at: Date.today } }
    end
    assert_response :not_found

    # Missing amount
    sign_in_as(@user)
    assert_no_difference("Prescription::Pack.count") do
      post prescription_packs_url(@prescription), params: { prescription_pack: { amount: nil, acquired_at: Date.today } }
    end
    assert_response :unprocessable_content

    # Non-integer amount
    assert_no_difference("Prescription::Pack.count") do
      post prescription_packs_url(@prescription), params: { prescription_pack: { amount: "abc", acquired_at: Date.today } }
    end
    assert_response :unprocessable_content

    # Future date
    assert_no_difference("Prescription::Pack.count") do
      post prescription_packs_url(@prescription), params: { prescription_pack: { amount: 30, acquired_at: Date.tomorrow } }
    end
    assert_response :unprocessable_content

    # Missing acquired_at
    assert_no_difference("Prescription::Pack.count") do
      post prescription_packs_url(@prescription), params: { prescription_pack: { amount: 30, acquired_at: nil } }
    end
    assert_response :unprocessable_content

    # Past date
    past_date = 5.days.ago.to_date
    assert_difference("Prescription::Pack.count") do
      post prescription_packs_url(@prescription), params: { prescription_pack: { amount: 30, acquired_at: past_date } }
    end
    assert_equal Prescription::Pack.last.acquired_at, past_date

    # Inactive prescription
    @prescription.update! active: false
    assert_no_difference("Prescription::Pack.count") do
      post prescription_packs_url(@prescription), params: { prescription_pack: { amount: 30, acquired_at: Date.today } }
    end
    assert_redirected_to root_url
  end
end
