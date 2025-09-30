class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  def new
    redirect_to root_path and return if authenticated?

    @user = User.new
    render_component(Registrations::NewComponent, user: @user)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for(@user)
      redirect_to root_path, notice: "Account created successfully!"
    else
      render_component(Registrations::NewComponent, user: @user)
    end
  end

  private

  def user_params
    # FIXED: Changed to permit first_name and last_name
    params.require(:user).permit(:first_name, :last_name, :email_address, :password, :password_confirmation)
  end
end
