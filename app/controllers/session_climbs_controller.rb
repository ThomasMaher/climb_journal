class SessionClimbsController < ApplicationController
  before_action :set_session_climb

  def show
    @boulder = @sc.boulder
  end

  def destroy
    session_id = @sc.session_id
    success = @sc.destroy ? true : false
    render json: { success: success, status: success ? :ok : :unprocessable_entity } unless success

    redirect_to session_url(session_id), status: :see_other
  end


  private

  def set_session_climb
    @sc = SessionClimb.find_by(id: params[:id])
    render status: :not_found and return unless @sc&.present?
  end
end
