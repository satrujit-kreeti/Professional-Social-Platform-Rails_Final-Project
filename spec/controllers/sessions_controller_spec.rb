# rubocop:disable all

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user, email: 'test@example.com', password: 'Super@71') }

    context 'with valid email and password' do
      it 'sets the user_id in the session and redirects to home_users_path' do
        post :create, params: { email: user.email, password: 'Super@71' }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(home_users_path)
        expect(flash[:notice]).to eq('Logged in sucesssfully')
      end
    end

    context 'with invalid email or password' do
      it 'displays an error message and re-renders the new template' do
        post :create, params: { email: user.email, password: 'wrong_password' }
        expect(session[:user_id]).to be_nil
        expect(flash[:alert]).to eq('Invalid email or password')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'clears the user_id from the session and redirects to root_path' do
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Logged out Successfully')
    end
  end
end
