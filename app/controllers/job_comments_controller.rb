class JobCommentsController < ApplicationController
  before_action :require_login

  def new
    @job_requirement = JobRequirement.find(params[:job_requirement_id])
    @job_comment = @job_requirement.job_comments.new
  end

  def create
    @job_requirement = JobRequirement.find(params[:job_requirement_id])
    @job_comment = @job_requirement.job_comments.build(comment_params)
    @job_comment.user = current_user

    if @job_comment.save
      redirect_to job_requirement_path(@job_requirement), notice: 'Comment created successfully.'
    else
      redirect_to job_requirement_path(@job_requirement), alert: 'Not able to create comment. Try again later'
    end
  end

  private

  def comment_params
    params.require(:job_comment).permit(:content)
  end

  def require_login
    return if current_user

    redirect_to root_path, notice: 'Please login to access this page'
  end
end
