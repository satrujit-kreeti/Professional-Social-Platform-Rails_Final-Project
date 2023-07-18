# app/controllers/admin/job_sectors_controller.rb
class Admin::JobSectorsController < ApplicationController
    before_action :require_admin
  
    def index
      @job_sectors = JobSector.all
    end
  
    def new
      @job_sector = JobSector.new
      @number = 3
      @job_roles = []
      @number.times { @job_roles << JobRole.new }
    end
    
    
    
    
    def create
      @job_sector = JobSector.new(job_sector_params)
      @job_roles = job_roles_params.map { |role_params| JobRole.new(role_params) }
    
      if @job_sector.save
        @job_roles.each { |role| role.job_sector_id = @job_sector.id }
        @job_roles.each { |role| @job_sector.job_roles.create(name: role.name) }
        redirect_to admin_job_sectors_path, notice: 'Job sector and roles created successfully.'
      else
        render :new
      end
    end

    def destroy
      @job_sector = JobSector.find(params[:id])
      @job_roles = @job_sector.job_roles

      if @job_role.nil?
        @job_sector.destroy
        redirect_to admin_job_sectors_path, notice: 'Job sector and roles deleted successfully.'
      else
        if @job_role.destroy && @job_sector.destroy
          redirect_to admin_job_sectors_path, notice: 'Job sector and roles deleted successfully.'
        else
          redirect_to admin_job_sectors_path, alert: 'Failed to delete job sector and roles.'
        end
      end
    end
    
    private
  
    def require_admin
      unless current_user&.admin?
        redirect_to root_path, notice: 'Access denied. Only admins can perform this action.'
      end
    end

    def job_sector_params 
      params.require(:job_sector).permit(:name)
    end
    
    def job_roles_params
      params.require(:job_sector).permit(job_roles: [:name])[:job_roles]
    end

  end
  

  