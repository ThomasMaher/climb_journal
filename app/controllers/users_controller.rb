class UsersController < ApplicationController
  def home_stats
    @user = User.includes(:sessions, session_climbs: :boulder).find_by(id: params[:user_id])
  end
end