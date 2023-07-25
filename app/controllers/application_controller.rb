class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  include NotificationHelper

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Error Handeling

  # rescue_from ActionController::RoutingError, with: :render_not_found
  # rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  # rescue_from ActionController::InvalidAuthenticityToken, with: :render_unprocessable_entity
  # rescue_from StandardError, with: :render_internal_server_error

  # def render_not_found
  #   render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  # end

  # def render_unprocessable_entity
  #   render file: "#{Rails.root}/public/422.html", layout: false, status: :unprocessable_entity
  # end

  # def render_internal_server_error
  #   render file: "#{Rails.root}/public/500.html", layout: false, status: :internal_server_error
  # end
end
