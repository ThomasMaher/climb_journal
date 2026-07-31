class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :create

  def home_stats
    user = User.includes(:sessions, session_climbs: :boulder).find(current_user.id)
    @user_stats = UserStatsService.new(user)
    render json: { overall: @user_stats.run, past_month: @user_stats.run(days_ago: 30) }
  end

  def create
    user = User.new(user_params)

    if user.save
      render :show, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :password_digest)
  end
end
