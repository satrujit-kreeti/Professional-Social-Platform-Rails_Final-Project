# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :check_admin
  def create
    @post = Post.find(params[:post_id])
    existing_like = @post.likes.find_by(user_id: current_user.id)

    if existing_like
      existing_like.destroy
      liked = false
    else
      @post.likes.create(user_id: current_user.id)
      liked = true
    end

    render json: { liked:, like_count: @post.likes.count }
  end

  def index
    @post = Post.find(params[:post_id])
    render json: { like_count: @post.likes.count }
  end

  private

  def check_admin
    return unless current_user&.admin?

    redirect_to home_path, alert: 'Admins are not allowed to access this page.'
  end
end
