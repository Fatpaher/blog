class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @header = "All Posts"
    @posts = Post.published.ordered
  end

  def show
    @post = Post.find(params[:id])
  end
end
