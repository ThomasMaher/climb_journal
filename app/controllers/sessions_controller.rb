class SessionsController < ApplicationController
    def index
        sessions = current_user.sessions
        render json: sessions
    end

    def show
        @session = current_user.sessions.includes(session_climbs: :boulder).find_by(id: params[:id])
        render json: { error: "No session found." }, status: :not_found and return unless @session.present?

        render :show
    end

    def create
        session = Session.new(session_params.merge(user_id: current_user.id))

        if session.save
            render json: session
        else
            render json: { errors: session.errors.as_json(full_messages: true) }, status: :unprocessable_entity
        end
    end

    def destroy
        session = Session.find_by(id: params[:id])
        render json: {}, status: :not_found and return unless session.present?
        render json: {}, status: :unauthorized and return unless session.user_id == current_user.id

        success = session.destroy ? true : false
        render json: { success: success }, status: success ? :ok : :unprocessable_entity
    end

    def session_stats
        session = current_user.sessions.includes(session_climbs: :boulder).find(params[:session_id])
        render json: { error: "No session found." }, status: :not_found and return unless session.present?

        session_stats_service = SessionStatsService.new(session)
        render json: session_stats_service.run
    end


    private

    def session_params
        params.require(:session).permit(:date, :gym_name, :notes)
    end
end
