require "application_system_test_case"

class UserAuthenticationTest < ApplicationSystemTestCase
  test "user can sign up, log in, and log out" do
    visit new_user_path
    fill_in "Email Address", with: "testuser@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_button "Sign Up"
    assert_content "Account created successfully"

    visit new_session_path
    fill_in "Email Address", with: "testuser@example.com"
    fill_in "Password", with: "password123"
    click_button "Log in"
    assert_no_content "Account created successfully"
    assert_no_content "Try another email address or password."

    # Optionally, check for a logout link or button and log out
    if page.has_link?("Log out")
      click_link "Log out"
      assert_content "Log in"
    end
  end
end
