require "test_helper"

class UsersTest < ActionDispatch::IntegrationTest
  test "GET /sign_up renders the registration form" do
    get new_user_path
    assert_response :success
    assert_includes @response.body, "Create your account"
  end

  test "POST /users with valid parameters creates a user and redirects to login" do
    assert_difference("User.count", 1) do
      post users_path, params: { user: { email_address: "test@example.com", password: "password123", password_confirmation: "password123" } }
    end
    assert_redirected_to new_session_path
    follow_redirect!
    assert_includes @response.body, "Account created successfully"
  end

  test "POST /users with invalid parameters does not create a user and re-renders the form" do
    assert_no_difference("User.count") do
      post users_path, params: { user: { email_address: "", password: "password123", password_confirmation: "different_password" } }
    end
    assert_response :unprocessable_entity
    assert_includes @response.body, "There were errors with your submission"
  end
end
