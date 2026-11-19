class SessionClimbsController < ApplicationController
  before_action :set_session_climb, except: :create

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

  # Used for adding an existing boulder to a user's existing session
  def create
    @session = Session.find(session_params[:session_id])
    @boulder = Boulder.find(session_params[:boulder_id])
    render json: { error: "Unable to find sessions with id #{session_params[:session_id]}" }, status: :not_found and return unless @session.present?
    render json: { error: "Unable to find boulder with id #{session_params[:boulder_id]}" }, status: :not_found and return unless @boulder.present?
    render json: {}, status: :unauthorized and return unless @session.user_id == @current_user.id

    @session_climb = SessionClimb.new(session_params.merge(user_id: @session.user_id))

    if @session_climb.save
      render "show", status: :created
    else
      render json: {
        error: @session_climb.errors[:boulder_id].present? ? "This boulder is already in the session." : "",
        errors: @session_climb.errors.as_json(full_messages: true)
      }, status: :unprocessable_entity
    end
  end


  private

  def set_session_climb
    @session_climb = SessionClimb.find_by(id: params[:id])
    render json: {}, status: :not_found and return unless @session_climb&.present?
  end

  def session_params
    params.require(:session).permit(
      :session_id,
      :boulder_id,
      :attempts,
      :percent_finished,
      :warmup
    )
  end
end
