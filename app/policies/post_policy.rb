class PostPolicy
  attr_reader :current_user, :post

  def initialize(current_user, post)
    @current_user = current_user
    @post = post
  end

  def create?
    current_user.admin? || current_user.writer?
  end

  def update?
    @current_user.admin? || current_user.id == post.user_id
  end

  def destroy?
    @current_user.admin? || current_user.id == post.user_id
  end
end
