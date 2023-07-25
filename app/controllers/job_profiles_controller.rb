class JobProfilesController < ApplicationController
  before_action :set_job_profile, only: %i[edit update destroy]

  def edit; end

  def update
    if @job_profile.update(job_profile_params)
      redirect_to profile_path, notice: 'Job profile was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @job_profile.destroy
    redirect_to profile_path, notice: 'Job profile was successfully deleted.'
  end

  def new
    @job_profile = JobProfile.new
  end

  def create
    @job_profile = JobProfile.new(job_profile_params)
    if @job_profile.save
      redirect_to profile_path, notice: 'Job profile was successfully added.'
    else
      render :new
    end
  end

  private

  def set_job_profile
    @job_profile = if action_name == 'new' || action_name == 'create'
                     JobProfile.new
                   else
                     current_user.job_profiles.find(params[:id])
                   end
  end

  def job_profile_params
    params.require(:job_profile).permit(:title, :user_id)
  end
end
