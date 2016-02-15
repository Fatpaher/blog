class PostsController < ApplicationController
  def index
    @posts = Post.all.order('created_at DESC')
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
  end

  def create
    @post = Post.new(params.require(:post).permit(:title, :body))
    @post.save
    redirect_to @post
  end
end
