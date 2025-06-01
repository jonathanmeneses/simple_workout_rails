require 'rails_helper'

describe UsersController, type: :controller do
  describe 'GET #new' do
    it 'assigns a new user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            email_address: 'test@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'creates a new user' do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'redirects to login with success message' do
        post :create, params: valid_params
        expect(response).to redirect_to(new_session_path)
        expect(flash[:notice]).to eq('Account created successfully. Please log in.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            email_address: '',
            password: 'password123',
            password_confirmation: 'different_password'
          }
        }
      end

      it 'does not create a new user' do
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)
      end

      it 're-renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'assigns user with errors' do
        post :create, params: invalid_params
        expect(assigns(:user)).to be_present
        expect(assigns(:user).errors).to be_present
      end
    end
  end
end
