class SessionClimbsController < ApplicationController
  before_action :set_session_climb

  def show
    render json: {}, status: :unauthorized and return unless @session_climb&.user_id == current_user.id

    @boulder = @session_climb.boulder
  end

  def destroy
    render json: {}, status: :unauthorized and return unless @session_climb&.user_id == current_user.id

    session_id = @session_climb.session_id
    success = @session_climb.destroy ? true : false
    render json: { success: success, status: success ? :ok : :unprocessable_entity } unless success

    redirect_to session_url(session_id), status: :see_other
  end


  private

  def set_session_climb
    @session_climb = SessionClimb.find_by(id: params[:id])
    render json: {}, status: :not_found and return unless @session_climb&.present?
  end
end
