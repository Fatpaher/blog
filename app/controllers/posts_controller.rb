class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.all.order("created_at DESC")
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(params.require(:post).permit(:title,
                                                                  :body))
    if @post.save
      redirect_to @post
    else
      render "new"
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = current_user.posts.find_by(params[:id])
    if @post
      if @post.update(params[:post].permit(:title, :body))
        redirect_to @post
      else
        render "edit"
      end
    else
      render status: :forbidden, text: "Access denied!"
    end
  end

  def destroy
    @post = current_user.posts.find_by(params[:id])
    if @post
      @post.destroy
      redirect_to root_path
    else
      render status: :forbidden, text: "Access denied!"
    end
  end
end
