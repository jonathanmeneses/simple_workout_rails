require 'rails_helper'

describe User, type: :model do
  it 'is valid with valid attributes' do
    user = User.new(email_address: 'test@example.com', password: 'password123', password_confirmation: 'password123')
    expect(user).to be_valid
  end

  it 'is invalid without an email_address' do
    user = User.new(password: 'password123', password_confirmation: 'password123')
    expect(user).not_to be_valid
  end

  it 'is invalid without a password' do
    user = User.new(email_address: 'test@example.com')
    expect(user).not_to be_valid
  end
end
