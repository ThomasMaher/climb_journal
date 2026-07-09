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
            render json: session.errors.as_json(full_messages: true), status: :unprocessable_entity
        end
    end


    private

    def session_params
        params.require(:session).permit(:date, :gym_name, :notes, :created_at, :updated_at)
    end
end