class AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: :create

  def user_status
    render json: current_user
  end

  def create
    user = User.find_by(username: user_params[:username])

    if user&.authenticate(user_params[:password_digest])
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  def destroy
    session.destroy(:user_id)
  end


  private

  def user_params
    params.require(:user).permit(:username, :password_digest)
  end
end
