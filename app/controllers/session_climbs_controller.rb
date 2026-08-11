class SessionClimbsController < ApplicationController
  def destroy
    sc = SessionClimb.find_by(id: params[:id])
    render status: :not_found and return unless sc.present?

    session_id = sc.session_id
    success = sc.destroy ? true : false
    render json: { success: success, status: success ? :ok : :unprocessable_entity } unless success

    redirect_to session_url(session_id), status: :see_other
  end
end
