class SessionsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    # FIXED: Added `and return` to stop execution after the redirect.
    redirect_to root_path and return if authenticated?

    render_component(Sessions::NewComponent)
  end

  def create
    user = User.find_by(email_address: params[:email_address])

    if user&.authenticate(params[:password])
      start_new_session_for(user)
      redirect_to after_authentication_url, notice: "Welcome back!"
    else
      render_component(Sessions::NewComponent, error: "Invalid email or password")
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "Signed out successfully"
  end
end
