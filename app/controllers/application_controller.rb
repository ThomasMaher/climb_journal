require "bcrypt"

class ApplicationController < ActionController::API
  before_action :authenticate_user!

  helper_method :current_user

  def current_user
    Rails.logger.debug("%%%%% Session user: #{session[:user_id]}")
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    head :unauthorized unless current_user
  end


  private

  def user_params
    params.require(:user).permit(:username, :password_digest)
  end
end
