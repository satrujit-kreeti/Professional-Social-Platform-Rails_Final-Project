# rubocop:disable all

require 'rails_helper'

RSpec.describe Admin::JobRolesController, type: :controller do
  let(:admin_user) { create(:user, role: 'admin') }
  
  before do
    allow(controller).to receive(:current_user).and_return(admin_user)
  end


  describe 'DELETE #destroy' do
    it 'destroys the job role' do
      job_role = create(:job_role)
      expect do
        delete :destroy, params: { id: job_role.id }
      end.to change(JobRole, :count).by(-1)
    end

    it 'redirects to admin_job_sectors_path with a success notice' do
      job_role = create(:job_role)
      delete :destroy, params: { id: job_role.id }
      expect(response).to redirect_to(admin_job_sectors_path)
      expect(flash[:notice]).to eq('Job role deleted successfully.')
    end

    it 'redirects to admin_job_sectors_path with an alert on failure' do
      allow_any_instance_of(JobRole).to receive(:destroy).and_return(false)
      job_role = create(:job_role)
      delete :destroy, params: { id: job_role.id }
      expect(response).to redirect_to(admin_job_sectors_path)
      expect(flash[:alert]).to eq('Failed to delete job role.')
    end
  end
end
