# rubocop:disable all

require 'rails_helper'

RSpec.describe Admin::JobSectorsController, type: :controller do
  let(:admin_user) { create(:user, role: 'admin') }
  
  before do
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  describe 'GET #index' do
    it 'assigns @job_sectors' do
      job_sectors = create_list(:job_sector, 3)
      get :index
      expect(assigns(:job_sectors)).to match_array(job_sectors)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new JobSector with nested JobRole' do
      get :new
      expect(assigns(:job_sector)).to be_a_new(JobSector)
      expect(assigns(:job_sector).job_roles.first).to be_a_new(JobRole)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new JobSector' do
        expect do
          job_sector = create(:job_sector)
        end.to change(JobSector, :count).by(1)
      end
    end

  end

  describe 'GET #job_roles' do
    it 'returns JSON response with job roles for a specific job sector' do
      job_sector = create(:job_sector)
      job_role = create(:job_role, job_sector: job_sector)
      get :job_roles, params: { id: job_sector.id }, format: :json
      expect(JSON.parse(response.body).first['name']).to eq('Valid Job Role')
    end
  end
end
