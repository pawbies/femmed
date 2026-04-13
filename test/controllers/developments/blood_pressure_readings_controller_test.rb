require "test_helper"

class Developments::BloodPressureReadingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @other_user = users(:bob)
    @bpr = blood_pressure_readings(:normal)
  end

  test "index" do
    get blood_pressure_readings_url
    assert_redirected_to new_session_url

    sign_in_as(@user)
    get blood_pressure_readings_url
    assert_response :success
  end

  test "index with period filter" do
    sign_in_as(@user)

    get blood_pressure_readings_url(period: "week")
    assert_response :success

    get blood_pressure_readings_url(period: "month")
    assert_response :success

    get blood_pressure_readings_url(period: "year")
    assert_response :success

    # Invalid period falls back to all
    get blood_pressure_readings_url(period: "invalid")
    assert_response :success
  end

  test "show" do
    get blood_pressure_reading_url(@bpr)
    assert_redirected_to new_session_url

    sign_in_as(@user)
    get blood_pressure_reading_url(@bpr)
    assert_response :success

    sign_in_as(@other_user)
    get blood_pressure_reading_url(@bpr)
    assert_response :not_found
  end

  test "new" do
    get new_blood_pressure_reading_url
    assert_redirected_to new_session_url

    sign_in_as(@user)
    get new_blood_pressure_reading_url
    assert_response :success
  end

  test "create" do
    post blood_pressure_readings_url, params: { blood_pressure_reading: { systolic: 118, diastolic: 76 } }
    assert_redirected_to new_session_url

    sign_in_as(@user)
    assert_difference("BloodPressureReading.count") do
      post blood_pressure_readings_url, params: { blood_pressure_reading: { systolic: 118, diastolic: 76, measured_at: Time.now } }
    end
    assert_redirected_to blood_pressure_reading_url(BloodPressureReading.last)
  end

  test "edit" do
    get edit_blood_pressure_reading_url(@bpr)
    assert_redirected_to new_session_url

    sign_in_as(@user)
    get edit_blood_pressure_reading_url(@bpr)
    assert_response :success

    sign_in_as(@other_user)
    get edit_blood_pressure_reading_url(@bpr)
    assert_response :not_found
  end

  test "update" do
    patch blood_pressure_reading_url(@bpr), params: { blood_pressure_reading: { systolic: 125 } }
    assert_redirected_to new_session_url

    sign_in_as(@user)
    patch blood_pressure_reading_url(@bpr), params: { blood_pressure_reading: { systolic: 125 } }
    assert_redirected_to blood_pressure_reading_url(@bpr)
    assert_equal 125, @bpr.reload.systolic.to_i

    sign_in_as(@other_user)
    patch blood_pressure_reading_url(@bpr), params: { blood_pressure_reading: { systolic: 999 } }
    assert_response :not_found
  end

  test "destroy" do
    delete blood_pressure_reading_url(@bpr)
    assert_redirected_to new_session_url

    sign_in_as(@user)
    assert_difference("BloodPressureReading.count", -1) do
      delete blood_pressure_reading_url(@bpr)
    end
    assert_redirected_to blood_pressure_readings_url
  end
end
