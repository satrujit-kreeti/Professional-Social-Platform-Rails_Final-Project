# rubocop:disable all


require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, role: 'admin') }


  describe 'GET #search' do
    it 'renders the search template' do
      get :search, params: { id: user.id }
      expect(response).to render_template(:search)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new user to @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'builds a new certificate for the user' do
      get :new
      expect(assigns(:user).certificates).not_to be_empty
      expect(assigns(:user).certificates.first).to be_a_new(Certificate)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_user_params) { attributes_for(:user) }

      it 'creates a new user' do
        expect do
          post :create, params: { user: valid_user_params }
        end.to change(User, :count).by(1)
      end

      it 'redirects to login page with success message' do
        post :create, params: { user: valid_user_params }
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq('User created successfully. Please log in')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_user_params) { attributes_for(:user, email: nil) }

      it 'does not create a new user' do
        expect do
          post :create, params: { user: invalid_user_params }
        end.not_to change(User, :count)
      end

      it 'renders the new template with error message' do
        post :create, params: { user: invalid_user_params }
        expect(response).to render_template(:new)
        expect(flash[:alert]).to be_present
      end
    end

  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }

    it 'updates the user and redirects to the profile_users_path on success' do
      new_attributes = { skills: 'NewSkillsname' }

      patch :update, params: { id: user.id, user: new_attributes }

      user.reload
      expect(user.skills).to eq('NewSkillsname')
      expect(response).to redirect_to(profile_users_path)
      expect(flash[:notice]).to eq('User was successfully updated.')
    end

    it 'renders the edit template with errors when update fails' do
      invalid_attributes = { username: '' }

      patch :update, params: { id: user.id, user: invalid_attributes }

      user.reload
      expect(user.username).not_to eq('')
      expect(response).to render_template(:edit)
    end
  end
end
