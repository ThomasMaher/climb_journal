require "bcrypt"

class ApplicationController < ActionController::API
  before_action :authenticate_user!

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])

    # test
    # @current_user ||= User.find_by(username: 'tmaher')
    # @current_user&.password_digest == 'password'
  end

  def authenticate_user!
    head :unauthorized unless current_user
  end


  private

  def user_params
    params.require(:user).permit(:username, :password_digest)
  end
end
