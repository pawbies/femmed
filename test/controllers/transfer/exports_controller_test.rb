require "test_helper"

class Transfer::ExportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
  end

  test "new" do
    # Not authenticated
    get new_export_url
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get new_export_url
    assert_response :success
  end

  test "create with no data selected redirects back" do
    # Not authenticated
    post export_url
    assert_redirected_to new_session_url

    # Authenticated, no data selected
    sign_in_as(@user)
    post export_url, params: { data: {} }
    assert_redirected_to new_export_url
  end

  test "create with prescriptions exports csv" do
    sign_in_as(@user)
    post export_url, params: { data: { prescriptions: "1" } }

    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.headers["Content-Disposition"], "femmed-export-alice-"

    body = response.body
    assert_includes body, "Prescription"
    assert_includes body, "Planned Dose"
    assert_includes body, "Active/Inactive"
    assert_includes body, "Created at"
    assert_includes body, "History"
  end

  test "create with profile exports csv" do
    sign_in_as(@user)
    post export_url, params: { data: { profile: "1" } }

    assert_response :success
    assert_equal "text/csv", response.media_type

    body = response.body
    assert_includes body, "Email address"
    assert_includes body, "Username"
    assert_includes body, @user.email_address
    assert_includes body, @user.username
  end

  test "create with both exports csv with all sections" do
    sign_in_as(@user)
    post export_url, params: { data: { prescriptions: "1", profile: "1" } }

    assert_response :success
    assert_equal "text/csv", response.media_type

    body = response.body
    assert_includes body, "Prescription"
    assert_includes body, "Email address"
  end

  test "create only exports current user's data" do
    other_user = users(:bob)
    sign_in_as(other_user)
    post export_url, params: { data: { prescriptions: "1" } }

    assert_response :success
    body = response.body

    # Bob's prescription should be present
    assert_includes body, "Adderall"

    # Alice's prescriptions should not be present
    assert_not_includes body, "Ritalin"
  end
end
