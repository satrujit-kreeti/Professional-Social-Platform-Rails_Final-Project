class UsersController < ApplicationController
  require 'elasticsearch'
  before_action :require_login, only: %i[home profile delete_account search]
  before_action :require_admin, only: %i[users_list search]

  def index
    @users = User.all
  end

  def show
    @users = if params[:query].present?
               User.search_items(params[:query]).records.where.not(role: 'admin')
             else
               User.where.not(role: 'admin')
             end
  end

  def new
    @user = User.new
    @user.certificates.build
  end

  def create
    @user = User.new(user_params)
    if params[:user][:certificates_documents].present?
      params[:user][:certificates_documents].each do |document|
        @user.certificates.build(certificate_document: document)
      end
    end

    # @user.job_profiles.build(title: "Title")

    User.__elasticsearch__.create_index! force: true
    User.import

    if @user.save
      redirect_to login_path, notice: 'User created successfully. Please log in'
    else
      flash[:alert] = @user.errors.full_messages.join(', ')

      render :new
    end
  end

  def profiles
    if User.find(params[:id]) == current_user
      render :profile
    else
      @user = User.find(params[:id])
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    User.__elasticsearch__.create_index! force: true
    User.import
    # sleep 1

    if @user.update(update_params)
      redirect_to profile_path, notice: 'User was successfully updated.'
    else
      flash[:alert] = @user.errors.full_messages.join(', ')

      render :edit
    end
  end

  def home
    @posts = Post.all

    @users = User.where(role: 'user')
    return unless current_user.nil?

    redirect_to root_path, notice: 'Please login to access this page'
  end

  def profile
    return unless current_user.nil?

    redirect_to root_path, notice: 'Please login to access this page'
  end

  def users_list
    @users = User.where(role: 'user')
    render 'users/users_list'
  end

  def delete_account
    @user = User.find(params[:id])

    User.transaction do
      @user.friendships.destroy_all
      Friendship.where(friend: @user).destroy_all

      @user.profile_photo.purge if @user.profile_photo.attached?
      @user.cv.purge if @user.cv.attached?
      @user.certificates.destroy_all

      @user.destroy

      if current_user.admin?
        redirect_to users_list_path, notice: 'User account deleted successfully.'
      else
        redirect_to root_path, notice: 'Your account has been deleted. Create a new account to use our app.',
                               status: :see_other
      end
    rescue StandardError => e
      redirect_to root_path, alert: 'An error occurred while deleting your account. Please try again.',
                             status: :see_other
      raise e
    end
  end

  def connect
    @user = User.find(params[:id])

    if current_user.friends.include?(@user)
      flash[:notice] = 'Already connected!'
    else
      friendship = current_user.friendships.find_or_initialize_by(friend_id: @user.id)
      friendship.update(connected: false, requested_by_user_id: current_user.id)

      send_connect_notification(@user)

      flash[:notice] = 'Friendship request sent!'
    end

    render :profiles
  end

  def disconnect
    @user = User.find(params[:id])
    friendship = current_user.friendships.find_by(friend_id: @user.id)
    friendship.destroy
    flash[:notice] = 'Successfully disconnected!'
    send_disconnect_notification(@user)

    if request.referer.include?('profiles')
      render :profiles
    else
      redirect_to user_connections_path(current_user)
    end
  end

  def connections
    @user = User.find(params[:id])
    @friends = @user.friends.where(friendships: { connected: true })
    @pending_requests = Friendship.where(friend_id: @user.id, connected: false)
    @requests = @user.friends.where(friendships: { connected: false })
  end

  def report
    @user = User.find(params[:id])
    @user.increment(:report)
    @user.save
    flash[:notice] = 'User reported successfully.'
    redirect_to @user
  end

  def edit_password
    @user = current_user
  end

  def update_password
    if current_user.update(password_params)
      # Successful password update
      flash[:notice] = 'Password updated successfully.'
      redirect_to root_path
    else
      # If there are validation errors, render the password change form again
      render :edit_password
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :linkedin_profile, :qualification, :experience,
                                 :current_organization, :skills, :relevant_skill_notification, :profile_photo, :cv, :cv_download_permission, certificates_attributes: %i[id name document], job_profiles_attributes: %i[id title _destroy])
  end

  def update_params
    params.require(:user).permit(:username, :linkedin_profile, :qualification, :current_organization, :skills,
                                 :experience, :relevant_skill_notification, :profile_photo, :cv, :cv_download_permission, certificates_attributes: %i[id name document], job_profiles_attributes: %i[id title _destroy])
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

    redirect_to root_path, notice: 'Access denied. Only admins can perform this action.'
  end
end
