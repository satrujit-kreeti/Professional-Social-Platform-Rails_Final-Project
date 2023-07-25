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

    # Retrieve user details
    id = job_requirement.user_id
    user_email = User.find(id).email
    user_name = User.find(id).username

    applicant_name = current_user.username
    applicant_email = current_user.email

    # Retrieve uploaded CV file
    cv_file = params[:cv]

    # Send email with user details and attached CV
    if cv_file.nil?
      redirect_to job_requirements_path, alert: 'No CV attached. Attch cv to submit the Application'
    else
      JobRequirementsMailer.apply_job(user_email, user_name, applicant_name, applicant_email, cv_file).deliver_now

      redirect_to job_requirements_path, notice: 'Application submitted successfully.'
    end
  end

  private

  def job_requirement_params
    params.require(:job_requirement).permit(:job_title, :job_description, :vacancies, :skills_required,
                                            :job_sector_id, :job_role_id)
  end
end
