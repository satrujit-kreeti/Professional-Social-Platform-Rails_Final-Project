# rubocop:disable all

require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:user) { create(:user) }
  let(:friend1) { create(:user) }
  let(:admin_user) { create(:user, role: 'admin') }
  let!(:friendship) { create(:friendship, user: friend1, friend: user, connected: false) }

  describe 'GET #pending_requests' do
    context 'when user is logged in' do
      before { sign_in(user) }

      it 'assigns @user' do
        get :pending_requests
        expect(assigns(:user)).to eq(user)
      end

      it 'assigns @pending_requests' do
        get :pending_requests
        expect(assigns(:pending_requests)).to eq([friendship])
      end

      it 'renders the :pending_requests template' do
        get :pending_requests
        expect(response).to render_template(:pending_requests)
      end
    end


    context 'when user is an admin' do
      before { sign_in(admin_user) }

      it 'redirects to home_path with an alert' do
        get :pending_requests
        expect(response).to redirect_to(home_path)
        expect(flash[:alert]).to eq('Admins are not allowed to access this page.')
      end
    end
  end

  describe 'POST #approve' do
    before { sign_in(user) }

    it 'updates the friendship status to connected' do
      friendship
      expect do
        post :approve, params: { id: friendship.id }
        friendship.reload
      end.to change(friendship, :connected).to(true)
    end

    it 'redirects to pending_requests_path with success message' do
      friendship
      post :approve, params: { id: friendship.id }
      expect(response).to redirect_to(pending_requests_path)
      expect(flash[:notice]).to eq('Friendship request approved.')
    end
  end

  describe 'DELETE #reject' do
    before { sign_in(user) }

    it 'destroys the friendship' do
      friendship
      expect do
        delete :reject, params: { id: friendship.id }
      end.to change(Friendship, :count).by(-1)
    end

    it 'redirects to pending_requests_path with success message' do
      friendship
      delete :reject, params: { id: friendship.id }
      expect(response).to redirect_to(pending_requests_path)
      expect(flash[:notice]).to eq('Friendship request rejected.')
    end
  end

  def sign_in(user)
    allow(controller).to receive(:current_user).and_return(user)
  end
end