# frozen_string_literal: true

class UsersController < ApplicationController
  include UsersHelper
  include UsersControllerConcern

  require 'elasticsearch'
  before_action :require_login, only: %i[home profile delete_account show]
  before_action :require_admin, only: %i[users_list show], except: %i[connect disconnect connections]

  def index
    @users = User.all
  end

  def new
    @user = User.new
    @user.certificates.build
  end

  def create
    @user = User.new(user_params)
    attach_certificates_documents if params[:user][:certificates_documents].present?
    create_and_import_elasticsearch_index
  end

  def edit
    @user = User.find(params[:id])
    @user.certificates.build
    if current_user.id != @user.id
      redirect_to profile_users_path, alert: 'You cant access other peoples profiile'
    elsif current_user.admin?
      redirect_to profile_users_path, alert: 'Admin cant edit its profiile' if current_user.admin?
    end
  end

  def update
    @user = User.find(params[:id])
    certificate
    if @user.update(update_params)
      redirect_to profile_users_path, notice: 'User was successfully updated.'
    else
      render :edit, alert: @user.errors.full_messages.join(', ')
    end
  end

  def delete_account
    @user = User.find(params[:id])
    User.transaction do
      delete_attributes
      @user.destroy
      redirect_after_deletion
    rescue StandardError => e
      redirect_to_error(e)
    end
  end

  private

  def certificate
    attach_certificates_documents if params[:user][:certificates_documents].present?
    User.__elasticsearch__.create_index! force: true
    User.import
  end

  def user_params
    params.require(:user).permit(
      common_attributes,
      :username,
      :password,
      :password_confirmation,
      certificates_attributes: %i[id name document],
      job_profiles_attributes: %i[id title _destroy]
    )
  end

  def delete_attributes
    delete_friendships
    purge_attachments
    destroy_certificates
    delete_posts
  end

  def update_params
    params.require(:user).permit(
      :username,
      common_attributes,
      certificates_attributes: %i[id name document],
      job_profiles_attributes: %i[id title _destroy]
    )
  end

  def common_attributes
    %i[ email
        linkedin_profile
        qualification
        current_organization
        skills
        experience
        relevant_skill_notification
        profile_photo
        cv
        cv_download_permission]
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def require_login
    return if current_user

    redirect_to root_path, notice: 'Please login to access this page'
  end

  def require_admin
    return if current_user&.admin?

    redirect_to home_users_path, notice: 'Access denied. Only admins can perform this action.'
  end
end
