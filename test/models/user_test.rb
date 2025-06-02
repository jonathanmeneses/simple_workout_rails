require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is valid with valid attributes" do
    user = User.new(email_address: "test@example.com", password: "password123", password_confirmation: "password123")
    assert user.valid?
  end

  test "is invalid without an email_address" do
    user = User.new(password: "password123", password_confirmation: "password123")
    assert_not user.valid?
  end

  test "is invalid without a password" do
    user = User.new(email_address: "test@example.com")
    assert_not user.valid?
  end
end
