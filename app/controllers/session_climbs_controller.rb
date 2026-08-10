class SessionClimbsController < ApplicationController
  def destroy
    sc = SessionClimb.find_by(id: params[:id])

    success = sc.destroy ? true : false
    render json: { success: success, status: success ? :ok : :unprocessable_entity }
  end
end
