class ProfilesController < ApplicationController
  def show
    @user = current_user
    render_component(Profiles::ShowComponent, user: @user)
  end

  def edit
    @user = current_user
    render_component(Profiles::EditComponent, user: @user)
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Your profile was updated successfully."
    else
      render_component(Profiles::EditComponent, user: @user)
    end
  end

  private

  def profile_params
    params.require(:user).permit(:first_name, :last_name, :phone, :address, :profile_picture)
  end
end
