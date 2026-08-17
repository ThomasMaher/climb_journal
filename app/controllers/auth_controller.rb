class AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: :create

  def user_status
    render json: current_user
  end

  def create
    user = User.find_by(username: user_params[:username])

    if user&.authenticate(user_params[:password_digest])
      Rails.logger.debug("%%%%%%%%%%%%% Setting user: #{user.id}")
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  def destroy
    session.delete(:user_id)
    render json: {}, status: :no_content
  end


  private

  def user_params
    params.require(:user).permit(:username, :password_digest)
  end
end
