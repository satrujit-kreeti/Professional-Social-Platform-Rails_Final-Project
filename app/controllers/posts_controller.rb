# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_login

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      send_post_creation_notification
      redirect_to home_users_path, notice: 'Post created successfully.'
    else
      flash.now[:alert] = 'Post field can\'t be empty'
      render :new
    end
  end

  def index
    @posts = Post.all
  end

  def show
    if Post.exists?(params[:id])
      post_exist
    else
      redirect_to home_users_path, alert: "Post doesn't exist"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    send_post_delete_notification(@post.user_id)
    @post.likes.destroy_all
    @post.comments.destroy_all
    @post.destroy
    redirect_to home_users_path, notice: 'Post deleted successfully.'
  end

  def approve
    post = Post.find(params[:id])
    if current_user.admin?
      post.update(status: 'approved')
      send_post_approve_notification(post.user_id)
      redirect_to home_users_path, notice: 'Post is approved.'
    else
      redirect_to root_path, alert: 'Only Admin can approve post.'
    end
  end

  def reject
    post = Post.find(params[:id])
    if current_user.admin?
      post.update(status: 'rejected')
      send_post_reject_notification(post.user_id)
      redirect_to home_users_path, notice: 'Post is rejected.'
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

  def post_exist
    @post = Post.find(params[:id])
    @user = @post.user
    @friends = current_user.friends.where(friendships: { connected: true })
    unless @friends.include?(@user) || @user == current_user
      redirect_to home_users_path,
                  alert: "You can't see the post"
    end
    @comment = Comment.new
  end

  def post_params
    params.require(:post).permit(:content)
  end

  def require_login
    return if current_user

    redirect_to root_path, notice: 'Please login to access this page'
  end
end
