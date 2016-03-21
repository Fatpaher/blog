class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def index?
    current_user.admin?
  end

  def show?
    current_user.admin? || current_user == user
  end

  def destroy?
    (current_user == user && user.not_admin?) ||
      (current_user.admin? && user.not_admin?)
  end
end
