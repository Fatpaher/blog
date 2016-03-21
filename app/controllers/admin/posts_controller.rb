class Admin::PostsController < AdminController
  def index
    status = params[:status].to_s
    @header = Post::STATUS_TITLE[status] || "All posts"
    if current_user.writer?
      @posts = current_user.posts.ordered
    elsif current_user.editor? || current_user.admin?
      @posts = Post.all.ordered
    else
      redirect_to root_path
    end
    @posts = @posts.send(status) if status.in? Post::STATUSES
  end

  def new
    @post = Post.new
    @submit_msg = "Create"
  end

  def create
    @post = current_user.posts.build(post_params)
    authorize @post
    if @post.save
      redirect_to @post
    else
      render "new"
    end
  end

  def edit
    @post = Post.find(params[:id])
    @submit_msg = "Edit"
  end

  def update
    @post = Post.find(params[:id])
    authorize @post
    if @post
      if @post.update(post_params)
        redirect_to @post
      else
        render "edit"
      end
    else
      render status: :forbidden, text: "Access denied!"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize @post
    @post.destroy
    redirect_to root_path
  end

  def status_change
    @post = if current_user.writer?
              current_user.posts.find(params[:id])
            else
              Post.all.find(params[:id])
            end
    @post.status = params[:status]
    @post.save!
    redirect_to :back
  end

  private

  def post_params
    params[:post].permit(:title, :body)
  end
end
