class UsersController < ApplicationController
  before_action :require_login, only: [:home, :profile, :delete_account]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if params[:user][:certificates_documents].present?
      params[:user][:certificates_documents].each do |document|
        @user.certificates.build(certificate_document: document)
      end
    end

    if @user.save
      redirect_to login_path, notice: 'User created successfully. Please log in'
    else
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
    @user = current_user

    if @user.update(update_params)
      redirect_to profile_path, notice: 'User details saved successfully.'
    else
      @errors = @user.errors.full_messages
    render :edit
    end
  end

  def home

    @users = User.all
    if current_user.nil?
      redirect_to root_path, notice: 'Please login to access this page'
    end
  end

  def profile
    if current_user.nil?
      redirect_to root_path, notice: 'Please login to access this page'
    end
  end

  def delete_account
    @user = User.find(params[:id])
  
    User.transaction do
      begin
        # Delete the user's friendships
        @user.friendships.destroy_all
  
        # Remove the user from other people's friendships
        Friendship.where(friend: @user).destroy_all
  
        # Delete associated attachments and certificates
        @user.profile_photo.purge if @user.profile_photo.attached?
        @user.cv.purge if @user.cv.attached?
        @user.certificates.destroy_all
  
        # Destroy the user
        @user.destroy
  
        redirect_to root_path, notice: 'Your account has been deleted. Create a new account to use our app.', status: :see_other
      rescue => e
        redirect_to root_path, alert: 'An error occurred while deleting your account. Please try again.', status: :see_other
        raise e
      end
    end
  end
  


  def connect
    @user = User.find(params[:id])
    
    unless current_user.friends.include?(@user)
      friendship = current_user.friendships.find_or_initialize_by(friend_id: @user.id)
      friendship.update(connected: false, requested_by_user_id: current_user.id)
      flash[:notice] = 'Friendship request sent!'
    else
      flash[:notice] = 'Already connected!'
    end
    
    render :profiles
  end
  
  
  
  def disconnect
    @user = User.find(params[:id])
    friendship = current_user.friendships.find_by(friend_id: @user.id)
    friendship.destroy
    flash[:notice] = 'Successfully disconnected!'
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
  end
  
    


  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :linkedin_profile, :qualification, :experience, :current_organization, :skills, :relevant_skill_notification, :profile_photo, :cv, :cv_download_permission, certificates_attributes: [:id, { document: [] }, :_destroy])
  end

  def update_params
    params.require(:user).permit(:username, :linkedin_profile, :qualification, :experience, :current_organization, :skills, :relevant_skill_notification, :profile_photo, :cv, :cv_download_permission, certificates_attributes: [:id, :name, { document: [] }, :_destroy])
  end
  
  
  def require_login
    unless current_user
      redirect_to root_path, notice: 'Please login to access this page'
    end
  end
end
