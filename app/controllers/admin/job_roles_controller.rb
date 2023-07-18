class Admin::JobRolesController < ApplicationController
    before_action :require_admin
  
    def index
      @job_roles = JobRole.all
    end
  
    def create
      @job_role = JobRole.new(job_role_params)
    
      if @job_role.save
        redirect_to admin_job_roles_path, notice: 'Job role created successfully.'
      else
        render :new
      end
    end

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
      unless current_user&.admin?
        redirect_to root_path, notice: 'Access denied. Only admins can perform this action.'
      end
    end

    def job_role_params
      params.require(:job_role).permit(:name)
    end
  end