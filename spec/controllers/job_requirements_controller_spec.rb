# rubocop:disable all

require 'rails_helper'

RSpec.describe JobRequirementsController, type: :controller do
    let(:admin_user) { create(:user, role: 'admin') }
    let(:regular_user) { create(:user) }
    let(:job_requirement_params) { attributes_for(:job_requirement) }
  
    describe 'GET #index' do
      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
  
      it 'assigns @job_requirements' do
        job_requirement = create(:job_requirement)
        get :index
        expect(assigns(:job_requirements)).to eq([job_requirement])
      end
    end
  
    describe 'GET #show' do
      it 'renders the show template' do
        job_requirement = create(:job_requirement)
        get :show, params: { id: job_requirement.id }
        expect(response).to render_template(:show)
      end
    end
  
    describe 'GET #my_jobs' do
      context 'when user is an admin' do
        it 'redirects to root_path with an alert' do
          sign_in(admin_user)
          get :my_jobs
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to be_present
        end
      end
  
      context 'when user is not an admin' do
        it 'renders the my_jobs template' do
          sign_in(regular_user)
          get :my_jobs
          expect(response).to render_template(:my_jobs)
        end
  
        it 'assigns @job_requirements' do
          job_requirement = create(:job_requirement, user: regular_user)
          sign_in(regular_user)
          get :my_jobs
          expect(assigns(:job_requirements)).to eq([job_requirement])
        end
      end
    end
  
    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new job requirement' do
          sign_in(regular_user)
          expect do
            job_requirement = create(:job_requirement)
          end.to change(JobRequirement, :count).by(1)
        end
      end
  
      context 'with invalid params' do
        it 'renders the new template with alert' do
          sign_in(regular_user)
          post :create, params: { job_requirement: job_requirement_params.merge(job_title: '') }
          expect(response).to render_template(:new)
        end
      end
    end
  
    describe 'POST #approve' do
      it 'approves the job requirement' do
        job_requirement = create(:job_requirement)
        sign_in(admin_user)
        post :approve, params: { id: job_requirement.id }
        expect(job_requirement.reload.status).to eq('approved')
        expect(response).to redirect_to(job_requirements_path)
        expect(flash[:notice]).to be_present
      end
    end
  
    describe 'POST #reject' do
      it 'rejects the job requirement' do
        job_requirement = create(:job_requirement)
        sign_in(admin_user)
        post :reject, params: { id: job_requirement.id }
        expect(job_requirement.reload.status).to eq('rejected')
        expect(response).to redirect_to(job_requirements_path)
        expect(flash[:notice]).to be_present
      end
    end

    def sign_in(user)
        @request.session[:user_id] = user.id
    end
  
  end
  