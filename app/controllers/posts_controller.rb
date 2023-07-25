class PostsController < ApplicationController
  before_action :require_admin, only: %i[index destroy]
  before_action :require_login, except: %i[index show]

  def new
    @user = User.find(params[:user_id])
    @post = @user.posts.build
  end

  def create
    @user = User.find(params[:user_id])
    @post = @user.posts.build(post_params)

    if @post.save
      redirect_to home_path, notice: 'Post created successfully.'
    else
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

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def require_login
    return if current_user

    redirect_to root_path, notice: 'Please login to access this page'
  end

  def require_admin
    return if current_user&.admin?

    redirect_to root_path, notice: 'You are not authorized to access this page'
  end
end
