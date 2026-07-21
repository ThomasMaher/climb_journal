class UsersController < ApplicationController
  def home_stats
    @user = User.includes(:session, session_climbs: :boulder).find_by(id: params[:id])
  end
end