class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def index?
    current_user_admin
  end

  def show?
    current_user_admin || current_user == user
  end

  def destroy?
    (current_user == user && not_admin) ||
      (current_user.role == "admin" && not_admin)
  end


  def current_user_admin
    @current_user.role == "admin" 
  end

  def not_admin
    user.role != "admin"
  end
end
