class PostPolicy
  attr_reader :current_user, :post

  def initialize(current_user, post)
    @current_user = current_user
    @post = post
  end

  def create?
    ["admin", "writer"].include?(current_user.role)
  end

  def destroy?
    @current_user.role == "admin"
  end
end
