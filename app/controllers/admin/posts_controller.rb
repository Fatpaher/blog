class Admin::PostsController < AdminController
  def index
    status = params[:status].to_s
    @header = Post::STATUS_TITLE[status] || "All posts"

    if %w[writer admin].include? current_user.role
      @posts = current_user.posts.ordered
    elsif %w[editor admin].include? current_user.role
      @posts = Post.all.ordered
    else
      redirect_to root_path
    end
    @posts = @posts.send(status) if status.in? Post::STATUSES
  end

  def new
    @post = Post.new
    @submit = "Create"
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
    @submit = "Edit"
  end

  def update
    @post = current_user.posts.find_by(params[:id])
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
    @post = current_user.posts.find_by(params[:id])
    if @post
      @post.destroy
      redirect_to root_path
    else
      render status: :forbidden, text: "Access denied!"
    end
  end

  def pending
    @post = current_user.posts.find(params[:id])
    @post.status = "pending"
    @post.save!
    redirect_to draft_admin_posts_path
  end

  private

  def post_params
    params[:post].permit(:title, :body)
  end
end
