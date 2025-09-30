class Admin::UsersController < ApplicationController
  # Add this before_action to secure the entire controller
  before_action :require_admin!

  def index
    @users = User.page(params[:page]).per(20)
    render_component(Admin::Users::IndexComponent, users: @users)
  end

  def show
    @user = User.find(params[:id])
    render_component(Admin::Users::ShowComponent, user: @user)
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User updated successfully"
    else
      render_component(Admin::Users::ShowComponent, user: @user)
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted successfully"
  end

  private

  # This new private method checks for admin privileges
  def require_admin!
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  def user_params
    # This line is now safe because the controller is protected
    params.require(:user).permit(:role)
  end
end
