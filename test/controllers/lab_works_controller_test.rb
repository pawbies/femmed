require "test_helper"

class LabWorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user       = users(:alice)
    @other_user = users(:bob)
    @lab_work   = lab_works(:lab_work)
  end

  test "index" do
    get lab_works_url
    assert_redirected_to new_session_url

    sign_in_as(@user)
    get lab_works_url
    assert_response :success
  end

  test "show" do
    get lab_work_url(@lab_work)
    assert_redirected_to new_session_url

    sign_in_as(@user)
    get lab_work_url(@lab_work)
    assert_response :success

    sign_in_as(@other_user)
    get lab_work_url(@lab_work)
    assert_response :not_found
  end

  test "new" do
    get new_lab_work_url
    assert_redirected_to new_session_url

    sign_in_as(@user)
    get new_lab_work_url
    assert_response :success
  end

  test "create" do
    post lab_works_url, params: { lab_work: { taken_at: Time.current } }
    assert_redirected_to new_session_url

    sign_in_as(@user)
    assert_difference("LabWork.count") do
      post lab_works_url, params: { lab_work: { taken_at: Time.current } }
    end
    assert_redirected_to lab_work_url(LabWork.last)

    assert_no_difference("LabWork.count") do
      post lab_works_url, params: { lab_work: { taken_at: "" } }
    end
    assert_response :unprocessable_content
  end

  test "destroy" do
    delete lab_work_url(@lab_work)
    assert_redirected_to new_session_url

    sign_in_as(@other_user)
    assert_no_difference("LabWork.count") do
      delete lab_work_url(@lab_work)
    end
    assert_response :not_found

    sign_in_as(@user)
    assert_difference("LabWork.count", -1) do
      delete lab_work_url(@lab_work)
    end
    assert_redirected_to lab_works_url
  end
end
