# frozen_string_literal: true

module Admin
  class JobSectorsController < ApplicationController
    before_action :require_admin, except: [:job_roles]

    def index
      @job_sectors = JobSector.all
    end

    def new
      @job_sector = JobSector.new
      @job_sector.job_roles.build
    end

    def create
      @job_sector = JobSector.new(job_sector_params)
      if @job_sector.save
        redirect_to admin_job_sectors_path, notice: 'Job Sector and Roles added successfully!'
      else
        flash[:alert] = @job_sector.errors.full_messages.join(', ')

        render :new
      end
    end

    def edit
      @job_sector = JobSector.find(params[:id])
    end

    def update
      @job_sector = JobSector.find(params[:id])
      if @job_sector.update(job_sector_params)
        redirect_to admin_job_sectors_path, notice: 'Job Sector and Roles updated successfully!'
      else
        flash[:alert] = @job_sector.errors.full_messages.join(', ')

        render :edit
      end
    end

    def destroy
      @job_sector = JobSector.find(params[:id])
      @job_roles = @job_sector.job_roles

      if @job_role.nil?
        @job_sector.destroy
        redirect_to admin_job_sectors_path, notice: 'Job sector and roles deleted successfully.'
      elsif @job_role.destroy && @job_sector.destroy
        redirect_to admin_job_sectors_path, notice: 'Job sector and roles deleted successfully.'
      else
        redirect_to admin_job_sectors_path, alert: 'Failed to delete job sector and roles.'
      end
    end

    def job_roles
      job_sector = JobSector.find(params[:id])
      job_roles = job_sector.job_roles

      render json: job_roles, only: %i[id name]
    end

    private

    def require_admin
      return if current_user&.admin?

      redirect_to root_path, notice: 'Access denied. Only admins can perform this action.'
    end

    def job_sector_params
      params.require(:job_sector).permit(:name, job_roles_attributes: %i[id name]).tap do |whitelisted|
        whitelisted[:job_roles_attributes].reject! { |_, attributes| attributes[:name].blank? }
      end
    end
  end
end
