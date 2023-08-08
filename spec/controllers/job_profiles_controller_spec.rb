# rubocop:disable all

require 'rails_helper'

RSpec.describe JobProfilesController, type: :controller do
  let(:user) { create(:user) }
  let(:job_profile) { create(:job_profile, user: user) }
  let(:valid_params) { attributes_for(:job_profile) }
  let(:invalid_params) { attributes_for(:job_profile, title: nil) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #edit' do
    it 'renders the :edit template' do
      get :edit, params: { id: job_profile.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the job profile' do
        patch :update, params: { id: job_profile.id, job_profile: valid_params }
        job_profile.reload
        expect(job_profile.title).to eq(valid_params[:title])
      end

      it 'redirects to profile_path with a success notice' do
        patch :update, params: { id: job_profile.id, job_profile: valid_params }
        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to eq('Job profile was successfully updated.')
      end
    end

    context 'with invalid params' do
      it 'does not update the job profile' do
        patch :update, params: { id: job_profile.id, job_profile: invalid_params }
        job_profile.reload
        expect(job_profile.title).not_to eq(invalid_params[:title])
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the job profile' do
      delete :destroy, params: { id: job_profile.id }
      expect(JobProfile.exists?(job_profile.id)).to be_falsey
    end

    it 'redirects to profile_path with a success notice' do
      delete :destroy, params: { id: job_profile.id }
      expect(response).to redirect_to(profile_path)
      expect(flash[:notice]).to eq('Job profile was successfully deleted.')
    end
  end

  describe 'GET #new' do
    it 'assigns a new job profile' do
      get :new
      expect(assigns(:job_profile)).to be_a_new(JobProfile)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'redirects to profile_path with a success notice' do
        expect do
            new_comment = create(:job_profile)
            post :create, params: { job_profile: valid_params }
        end.to change(JobProfile, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'does not create a new job profile' do
        expect do
          post :create, params: { job_profile: invalid_params }
        end.not_to change(JobProfile, :count)
      end

      
    end
  end
end
