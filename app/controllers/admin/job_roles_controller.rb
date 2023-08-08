# frozen_string_literal: true

module Admin
  class JobRolesController < ApplicationController
    before_action :require_admin

    def destroy
      @job_role = JobRole.find(params[:id])
      if @job_role.destroy
        redirect_to admin_job_sectors_path, notice: 'Job role deleted successfully.'
      else
        redirect_to admin_job_sectors_path, alert: 'Failed to delete job role.'
      end
    end

    private

    def require_admin
      return if current_user&.admin?

      redirect_to root_path, notice: 'Access denied. Only admins can perform this action.'
    end

    def job_role_params
      params.require(:job_role).permit(:name)
    end
  end
end
