class SessionsController < ApplicationController
    before_action :set_user

    def index
        sessions = Session.where(user_id: params[:user_id])
        render json: sessions
    end

    def show
        @session = Session.includes(session_climbs: :boulder).find_by(id: params[:id])
        render json: { error: 'No session found.' }, status: :not_found and return unless @session.present?

        render :show
    end

    def create
        session = Session.new(session_params.merge(user_id: params[:user_id]))

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

    def set_user
        render json: { error: 'User not found.' }, status: :not_found and return unless params[:user_id].present?
    end

    def session_params
        params.require(:session).permit(:date, :gym_name, :notes)
    end
end