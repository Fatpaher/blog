class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :destroy]
  def index
    @users = User.all
    authorize User
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    if user && current_user.role == "admin"
      user.destroy
      redirect_to users_path
    elsif user
      user.destroy
      redirect_to root_path
    else
      redirect_to root_path
    end
  end
end
