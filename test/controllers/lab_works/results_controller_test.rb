require "test_helper"

class LabWorks::ResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user       = users(:alice)
    @other_user = users(:bob)
    @lab_work   = lab_works(:lab_work)
    @bio_marker = bio_markers(:glucose)
  end

  test "new" do
    get new_lab_work_result_url(@lab_work)
    assert_redirected_to new_session_url

    sign_in_as(@user)
    get new_lab_work_result_url(@lab_work)
    assert_response :success

    sign_in_as(@other_user)
    get new_lab_work_result_url(@lab_work)
    assert_response :not_found
  end

  test "create" do
    valid_params = { lab_work_result: { bio_marker_id: @bio_marker.id, value: 95.0 } }

    post lab_work_results_url(@lab_work), params: valid_params
    assert_redirected_to new_session_url

    sign_in_as(@user)
    assert_difference("LabWork::Result.count") do
      post lab_work_results_url(@lab_work), params: valid_params
    end
    assert_redirected_to lab_work_url(@lab_work)

    assert_no_difference("LabWork::Result.count") do
      post lab_work_results_url(@lab_work), params: { lab_work_result: { bio_marker_id: @bio_marker.id, value: "" } }
    end
    assert_response :unprocessable_content

    sign_in_as(@other_user)
    assert_no_difference("LabWork::Result.count") do
      post lab_work_results_url(@lab_work), params: valid_params
    end
    assert_response :not_found
  end
end
