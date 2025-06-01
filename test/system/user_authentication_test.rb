require "application_system_test_case"

class UserAuthenticationTest < ApplicationSystemTestCase
  test "user can sign up, log in, and log out" do
    visit new_user_path
    fill_in "Email Address", with: "testuser@example.com"
    fill_in "Password", with: "password123"
    fill_in "Confirm Password", with: "password123"
    click_button "Sign Up"
    assert_content "Account created successfully"

    visit new_session_path
    fill_in "Email Address", with: "testuser@example.com"
    fill_in "Password", with: "password123"
    click_button "Sign in"
    assert_no_content "Account created successfully"
    assert_no_content "Try another email address or password."

    # Check that user is logged in (should see their email in nav)
    assert_content "Hello, testuser@example.com"

    # Log out
    click_button "Log out"
    assert_content "Sign in to your account"
    assert_no_content "Hello, testuser@example.com"
  end
end
