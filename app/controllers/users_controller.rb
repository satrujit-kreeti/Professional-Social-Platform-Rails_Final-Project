class UsersController < ApplicationController
  before_action :require_login, only: [:home, :profile]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to login_path, notice: 'User created successfully. Please log in'
    else
      render :new
    end
  end

  def profiles
    if User.find(params[:id]) == current_user
      redirect_to profile_path
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
    user = current_user
    user.destroy

    redirect_to root_path, notice: 'Your account has been deleted. Create a new account to use our app'

  end

  private

  def user_params
      params.require(:user).permit(:username, :email, :password, :linkedin_profile, :qualification, :experience, :current_organization, :skills, :relevant_skill_notification, :profile_photo)
  end


  def update_params
      params.require(:user).permit(:username, :linkedin_profile, :qualification, :experience, :current_organization, :skills, :relevant_skill_notification, :profile_photo)
  end

  def require_login
    unless current_user
      redirect_to root_path, notice: 'Please login to access this page'
    end
  end
  end
