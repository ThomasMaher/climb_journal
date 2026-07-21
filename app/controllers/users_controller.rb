class UsersController < ApplicationController
  def home_stats
    user = User.includes(:sessions, session_climbs: :boulder).find_by(id: params[:user_id])
    @user_stats = UserStatsService.new(user)
    render json: { overall: @user_stats.run, past_month: @user_stats.run(days_ago: 30) }
  end
end