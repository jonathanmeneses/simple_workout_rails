require 'rails_helper'

RSpec.describe "User Registration", type: :request do
  describe "GET /sign_up" do
    it "renders the registration form" do
      get new_user_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Create your account")
    end
  end

  describe "POST /users" do
    context "with valid parameters" do
      let(:valid_params) do
        { user: { email_address: "test@example.com", password: "password123", password_confirmation: "password123" } }
      end

      it "creates a new user and redirects to login" do
        expect {
          post users_path, params: valid_params
        }.to change(User, :count).by(1)
        expect(response).to redirect_to(new_session_path)
        follow_redirect!
        expect(response.body).to include("Account created successfully")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        { user: { email_address: "", password: "password123", password_confirmation: "different_password" } }
      end

      it "does not create a user and re-renders the form" do
        expect {
          post users_path, params: invalid_params
        }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("There were errors with your submission")
      end
    end
  end
end
