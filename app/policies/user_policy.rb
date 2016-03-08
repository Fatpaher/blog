class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def index?
    @current_user.role == "admin"
  end

  def show?
    @current_user.role == "admin" || current_user == user
  end

  def destroy?
    (current_user == user && user.role != "admin") ||
      (current_user.role == "admin" && user.role != "admin")
  end
end
