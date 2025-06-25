require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_registration_url
    assert_response :success
  end

  test "should get create" do
    post registration_url, params: {
      user: {
        username: "testuser",
        email_address: "test@example.com",
        password: "password",
        password_confirmation: "password"
      }
    }
    assert_response :redirect
    assert_redirected_to root_path
  end
end
