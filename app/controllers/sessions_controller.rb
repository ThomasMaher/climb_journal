class SessionsController < ApplicationController
    def index
        sessions = Session.all
        render json: sessions
    end

    def show
        session = Session.find_by(id: params[:id])
        render status: :not_found and return unless session.present?

        render json: session
    end

    def create
        session = Session.new(session_params)

        if session.save
            render json: session
        else
            render json: { errors: session.errors.as_json(full_messages: true) }, status: :unprocessable_entity
        end
    end

    def destroy
        session = Session.find_by(id: params[:id])
        render status: :not_found and return unless session.present?

        success = session.destroy ? true : false
        render json: { success: success }, status: success ? :ok : :unprocessable_entity
    end


    private

    def session_params
        params.require(:session).permit(:date, :gym_name, :notes)
    end
end