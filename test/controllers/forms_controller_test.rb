require "test_helper"

class FormsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @form = forms(:tablet)
    @user    = users(:alice)
    @admin   = users(:admin)
  end

  test "index" do
    # Not authenticated
    get forms_url
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get forms_url
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get forms_url
    assert_response :success
  end

  test "show" do
    # Not authenticated
    get form_url(@form)
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get form_url(@form)
    assert_redirected_to root_path

    # Admin
    sign_in_as(@admin)
    get form_url(@form)
    assert_response :success
  end

  test "new" do
    # Not authenticated
    get new_form_url
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get new_form_url
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get new_form_url
    assert_response :success
  end

  test "create" do
    # Not authenticated
    post forms_url, params: { form: { name: "Test" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    assert_no_difference "Form.count" do
      post forms_url, params: { form: { name: "Test" } }
    end
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    assert_difference "Form.count" do
      post forms_url, params: { form: { name: "Femboy Capsule" } }
    end
    assert_redirected_to form_url(Form.last)

    # Admin with invalid params
    assert_no_difference "Form.count" do
      post forms_url, params: { form: { name: "" } }
    end
    assert_response :unprocessable_content
  end

  test "edit" do
    # Not authenticated
    get edit_form_url(@form)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    get edit_form_url(@form)
    assert_redirected_to root_url

    # Admin
    sign_in_as(@admin)
    get edit_form_url(@form)
    assert_response :success
  end

  test "update" do
    # Not authenticated
    patch form_url(@form), params: { form: { name: "Updated" } }
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    patch form_url(@form), params: { form: { name: "Updated" } }
    assert_redirected_to root_url

    # Admin with valid params
    sign_in_as(@admin)
    patch form_url(@form), params: { form: { name: "Updated" } }
    assert_redirected_to form_url(@form)
    assert_equal "Updated", @form.reload.name

    # Admin with invalid params
    patch form_url(@form), params: { form: { name: "" } }
    assert_response :unprocessable_content
  end

  test "destroy" do
    # Not authenticated
    delete form_url(@form)
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as(@user)
    assert_no_difference "Form.count" do
      delete form_url(@form)
    end
    assert_redirected_to root_url

    # Admin - non empty form
    sign_in_as(@admin)
    assert_no_difference "Form.count" do
      delete form_url(@form)
    end
    assert_redirected_to form_url(@form)

    # Admin - non empty form
    f = Form.create name: "empty"
    assert_difference "Form.count", -1 do
      delete form_url(f)
    end
    assert_redirected_to root_url
  end
end
