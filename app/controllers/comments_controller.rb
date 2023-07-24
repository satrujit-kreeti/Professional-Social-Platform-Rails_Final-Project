class CommentsController < ApplicationController
    before_action :require_login

    def new
      @post = Post.find(params[:post_id])
      @comment = @post.comments.new
    end
  
    def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.build(comment_params)
      @comment.user = current_user
  
      if @comment.save
        redirect_to post_path(@post), notice: 'Comment created successfully.'
      else
        redirect_to post_path(@post), alert: 'Not able to create comment. Try again later'
      end
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  
    def require_login
      unless current_user
        redirect_to root_path, notice: 'Please login to access this page'
      end
    end
  end
  