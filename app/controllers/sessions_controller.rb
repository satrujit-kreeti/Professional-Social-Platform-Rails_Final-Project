# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      redirect_to home_path, notice: 'Logged in sucesssfully'

    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out Successfully'
  end

  def linkedin
    auth = request.env['omniauth.auth']
    user = find_or_create_user_from_linkedin(auth)
    if user
      session[:user_id] = user.id
      # redirect_to edit_user_path(current_user), notice: 'Logged in successfully.'
      redirect_to home_path, notice: 'Logged in successfully.'

    else
      redirect_to root_path, alert: 'Failed to create an account.'
    end
  end

  def failure
    flash[:alert] = 'There was an error while trying to authenticate your account.'
    redirect_to root_path
  end

  private

  def find_or_create_user_from_linkedin(auth)
    User.where(email: auth.info.email).first_or_create do |new_user|
      set_user_attributtes(auth, new_user)
    end
  end

  def set_user_attributtes(auth, new_user)
    new_user.username = "#{auth.info.first_name} #{auth.info.last_name}"
    if auth.info.picture_url?
      temp_file = Down.download(auth.info.picture_url)
      new_user.profile_photo.attach(io: temp_file, filename: 'profile_photo.jpg')
    end
    new_user.password = SecureRandom.hex(10)
  end
end
