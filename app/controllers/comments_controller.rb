class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  def create
    post = Post.find(params[:post_id])
    comment = post.comments.build(params[:comment].permit(:name, :body))
    comment.user_id = current_user.id
    comment.name = comment.user.email
    if comment.save
      redirect_to post_path(post)
      flash[:success] = "Comment added."
    else
      redirect_to post_path(post)
      flash[:warning] = "Error"
    end
  end

  def destroy
    post = Post.find(params[:post_id])
    comment = post.comments.find(params[:id])
    comment.destroy
    redirect_to post_path(post)
    flash[:success] = "Comment deleted"
  end
end
