# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      redirect_to home_users_path, notice: 'Logged in sucesssfully'

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
      redirect_to home_users_path, notice: 'Logged in successfully.'

    else
      redirect_to root_path, alert: 'Failed to create an account.'
    end
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
    new_user.password = generate_complex_password
  end

  def generate_complex_password(length = 12)
    lowercase_letters = ('a'..'z').to_a
    uppercase_letters = ('A'..'Z').to_a
    digits = ('0'..'9').to_a
    special_characters = ['!', '@', '#', '$', '%', '^', '&', '*']
    all_characters = lowercase_letters + uppercase_letters + digits + special_characters
    password = [lowercase_letters.sample, uppercase_letters.sample, digits.sample, special_characters.sample]
    password += all_characters.sample(length - password.length)
    password.shuffle.join
  end
end
