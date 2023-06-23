class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
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
  @user = User.find_by(email: auth.info.email)

  if @user.nil?
    @user = User.new(user_params(auth))
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path, notice: 'User created and logged in with LinkedIn successfully'
    else
      render :new, alert: 'Failed to create user. Please sign up.'
    end
  else
    session[:user_id] = @user.id
    redirect_to home_path, notice: 'Logged in with LinkedIn successfully'
  end
end


  private

  def user_params(auth)
    {
      username: auth.info.name,
      email: auth.info.email,
      password: SecureRandom.hex(10),
      linkedin_profile: auth.info.urls.public_profile,
      qualification: auth.extra.raw_info.educations.first.degree,
      experience: auth.extra.raw_info.positions.first.title,
      current_organization: auth.extra.raw_info.positions.first.company.name,
      skills: auth.extra.raw_info.skills.values.map { |skill| skill.skill.name }.join(','),
      relevant_skill_notification: false,
      profile_photo: auth.info.image
    }
  end
end
