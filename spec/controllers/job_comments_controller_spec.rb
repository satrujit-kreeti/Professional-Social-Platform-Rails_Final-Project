# rubocop:disable all

require 'rails_helper'

RSpec.describe JobCommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:job_requirement) { create(:job_requirement) }
  let(:valid_params) { attributes_for(:job_comment) }
  let(:invalid_params) { attributes_for(:job_comment, content: nil) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #new' do
    it 'assigns @job_requirement and @job_comment' do
      get :new, params: { job_requirement_id: job_requirement.id }
      expect(assigns(:job_requirement)).to eq(job_requirement)
      expect(assigns(:job_comment)).to be_a_new(JobComment)
    end

    it 'renders the :new template' do
      get :new, params: { job_requirement_id: job_requirement.id }
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new job comment' do
        expect do
          post :create, params: { job_requirement_id: job_requirement.id, job_comment: valid_params }
        end.to change(JobComment, :count).by(1)
      end

      it 'redirects to the job requirement path with a success notice' do
        post :create, params: { job_requirement_id: job_requirement.id, job_comment: valid_params }
        expect(response).to redirect_to(job_requirement_path(job_requirement))
        expect(flash[:notice]).to eq('Comment created successfully.')
      end
    end

    context 'with invalid params' do
      it 'does not create a new job comment' do
        expect do
          post :create, params: { job_requirement_id: job_requirement.id, job_comment: invalid_params }
        end.not_to change(JobComment, :count)
      end

      it 'redirects to the job requirement path with an alert message' do
        post :create, params: { job_requirement_id: job_requirement.id, job_comment: invalid_params }
        expect(response).to redirect_to(job_requirement_path(job_requirement))
        expect(flash[:alert]).to eq('Not able to create comment. Try again later')
      end
    end
  end
end
