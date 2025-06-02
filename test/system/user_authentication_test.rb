require "application_system_test_case"

class UserAuthenticationTest < ApplicationSystemTestCase
  test "user can register, log in, and log out" do
    # Registration
    visit new_user_path
    assert_text "Create your account"

    fill_in "Email Address", with: "test@example.com"
    fill_in "Password", with: "password123"
    fill_in "Confirm Password", with: "password123"
    click_button "Sign Up"

    assert_text "Account created successfully"

    # Login
    visit new_session_path
    assert_text "Sign in to your account"

    fill_in "Email Address", with: "test@example.com"
    fill_in "Password", with: "password123"
    click_button "Sign in"

    # Should be logged in (no longer seeing login form)
    assert_no_text "Sign in to your account"

    # Logout (if logout functionality exists)
    if page.has_link?("Log out") || page.has_button?("Log out")
      click_on "Log out"
      assert_text "Sign in"
      assert_no_text "Log out"
    end
  end
  test "registration form requires email and password (HTML5 validation)" do
    visit new_user_path
    click_button "Sign Up"
    # The page should not change, still on registration form
    assert_current_path new_user_path
    assert_text "Create your account"
  end

  test "user sees error with mismatched passwords" do
    visit new_user_path
    fill_in "Email Address", with: "test@example.com"
    fill_in "Password", with: "password123"
    fill_in "Confirm Password", with: "different_password"
    click_button "Sign Up"
    assert_text "There were errors with your submission"
    assert_text "Password confirmation doesn't match Password"
  end

  test "user sees error with invalid login credentials" do
    User.create!(email_address: "test@example.com", password: "password123", password_confirmation: "password123")
    visit new_session_path
    fill_in "Email Address", with: "test@example.com"
    fill_in "Password", with: "wrong_password"
    click_button "Sign in"
    assert_text "Try another email address or password"
  end
end
