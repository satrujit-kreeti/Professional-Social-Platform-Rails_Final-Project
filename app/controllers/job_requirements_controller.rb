# frozen_string_literal: true

class JobRequirementsController < ApplicationController
  def index
    @job_requirements = JobRequirement.all
  end

  def show
    @job_requirement = JobRequirement.find(params[:id])
  end

  def my_jobs
    if current_user.admin?
      redirect_to root_path, alert: "This page doesn't not exist for admin ."
    else
      @job_requirements = current_user.job_requirements
    end
  end

  def new
    @job_requirement = JobRequirement.new
  end

  def create
    @job_requirement = JobRequirement.new(job_requirement_params)
    @job_requirement.user_id = current_user.id

    if @job_requirement.save
      send_job_post_creation_notification
      redirect_to job_requirements_path, notice: 'Job requirement created successfully.'
    else
      flash[:alert] = @job_requirement.errors.full_messages.join(', ')
      render :new
    end
  end

  def approve
    job_requirement = JobRequirement.find(params[:id])
    job_requirement.update(status: 'approved')

    send_job_post_approve_notification(job_requirement.user_id)
    send_new_post_notification(job_requirement.skills_required, job_requirement.user_id)

    redirect_to job_requirements_path, notice: 'Job requirement approved.'
  end

  def reject
    job_requirement = JobRequirement.find(params[:id])
    job_requirement.update(status: 'rejected')
    redirect_to job_requirements_path, notice: 'Job requirement rejected.'
  end

  def apply
    job_requirement = JobRequirement.find(params[:id])
    user = User.find(job_requirement.user_id)
    cv_file = params[:cv]
    if cv_file.nil?
      redirect_with_alert('No CV attached. Attach CV to submit the Application')
    else
      send_application_email(user, cv_file)
      redirect_with_notice('Application submitted successfully.')
    end
  end

  private

  def redirect_with_alert(alert_message)
    redirect_to job_requirements_path, alert: alert_message
  end

  def redirect_with_notice(notice_message)
    redirect_to job_requirements_path, notice: notice_message
  end

  def send_application_email(user, cv_file)
    JobRequirementsMailer.apply_job(
      user.email,
      user.username,
      current_user.username,
      current_user.email,
      cv_file
    ).deliver_now
  end

  def job_requirement_params
    params.require(:job_requirement).permit(
      :job_title,
      :job_description,
      :vacancies,
      :skills_required,
      :job_sector_id,
      :job_role_id
    )
  end
end
