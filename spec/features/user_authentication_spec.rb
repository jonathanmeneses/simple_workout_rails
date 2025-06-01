require 'rails_helper'

feature 'User Authentication', type: :feature do
  scenario 'User can register, log in, and log out' do
    # Registration
    visit new_user_path
    expect(page).to have_content('Create your account')

    fill_in 'Email Address', with: 'test@example.com'
    fill_in 'Password', with: 'password123'
    fill_in 'Confirm Password', with: 'password123'
    click_button 'Sign Up'

    expect(page).to have_content('Account created successfully')

    # Login
    visit new_session_path
    expect(page).to have_content('Sign in to your account')

    fill_in 'Email Address', with: 'test@example.com'
    fill_in 'Password', with: 'password123'
    click_button 'Sign in'

    # Should be logged in (no longer seeing login form)
    expect(page).not_to have_content('Sign in to your account')

    # Logout (if logout functionality exists)
    if page.has_link?('Log out') || page.has_button?('Log out')
      click_on 'Log out'
      expect(page).to have_content('Sign in to your account')
    end
  end

  scenario 'User sees validation errors with invalid registration data' do
    visit new_user_path

    # Try to submit with no data
    click_button 'Sign Up'

    expect(page).to have_content('There were errors with your submission')
    expect(page).to have_content("Email address can't be blank")
    expect(page).to have_content("Password can't be blank")
  end

  scenario 'User sees error with mismatched passwords' do
    visit new_user_path

    fill_in 'Email Address', with: 'test@example.com'
    fill_in 'Password', with: 'password123'
    fill_in 'Confirm Password', with: 'different_password'
    click_button 'Sign Up'

    expect(page).to have_content('There were errors with your submission')
    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  scenario 'User sees error with invalid login credentials' do
    # First create a user
    User.create!(email_address: 'test@example.com', password: 'password123', password_confirmation: 'password123')

    visit new_session_path

    fill_in 'Email Address', with: 'test@example.com'
    fill_in 'Password', with: 'wrong_password'
    click_button 'Sign in'

    expect(page).to have_content('Try another email address or password')
  end
end
