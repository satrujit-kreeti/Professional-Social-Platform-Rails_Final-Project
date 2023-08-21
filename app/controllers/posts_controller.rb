# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_login

  def new
    @user = User.find(params[:user_id])
    @post = @user.posts.build
  end

  def create
    @user = User.find(params[:user_id])
    @post = @user.posts.build(post_params)

    if @post.save
      send_post_creation_notification
      redirect_to home_path, notice: 'Post created successfully.'
    else
      flash.now[:alert] = 'Post field can\'t be empty'
      render :new
    end
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @friends = @user.friends.where(friendships: { connected: true })
    @comment = Comment.new
  end

  def destroy
    @post = Post.find(params[:id])
    @post.likes.destroy_all
    @post.comments.destroy_all
    @post.destroy
    redirect_to home_path, notice: 'Post deleted successfully.'
  end

  def approve
    post = Post.find(params[:id])
    if current_user.admin?
      post.update(status: 'approved')
      send_post_approve_notification(post.user_id)

      redirect_to home_path, notice: 'Job requirement approved.'
    else
      redirect_to root_path, alert: 'Only Admin can approve post.'
    end
  end

  def reject
    post = Post.find(params[:id])
    if current_user.admin?
      post.update(status: 'rejected')
      redirect_to home_path, notice: 'Job requirement rejected.'
    else
      redirect_to root_path, alert: 'Only Admin can reject post.'
    end
  end

  def my_posts
    if current_user.admin?
      redirect_to root_path, alert: "This page doesn't not exist for admin ."
    else
      @posts = current_user.posts
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def require_login
    return if current_user

    redirect_to root_path, notice: 'Please login to access this page'
  end
end
