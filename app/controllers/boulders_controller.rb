class BouldersController < ApplicationController
  def index
    render json: {message: 'Coming soon.'}
  end

  def show
    boulder = Boulder.find(params[:id])

    render json: boulder
  end

  def create
    render json: {
      errors: ["Only one session climb allowed per session"]
    }, status: :unprocessable_entity and return unless session_climbs_valid?
    @boulder = Boulder.new(boulder_params)

    if @boulder.save
      set_session_climb
      render :show, status: :created
    else
      render json: { errors: @boulder.errors.as_json(full_messages: true) }, status: :unprocessable_entity
    end
  end

  def destroy
    boulder = Boulder.find(params[:id])

    success = boulder.destroy ? true : false
    render json: { success: success, status: success ? :ok : :unprocessable_entity }
  end


  private

  def boulder_params
    params.require(:boulder).permit(
      :vgrade_range_min,
      :vgrade_range_max,
      :self_grade,
      :rating,
      :notes,
      :boulder_type,
      :incline,
      :nickname,
      session_climbs_attributes: [
        :session_id,
        :attempts,
        :percent_finished,
        :notes
      ]
    )
  end

  def session_climbs_valid?
    boulder_params.present? && (
      boulder_params[:session_climbs_attributes].nil? || (
        boulder_params[:session_climbs_attributes].size < 2 &&
        boulder_params[:session_climbs_attributes][0][:session_id].present? # There should be a different error for cases when session_id comes up null
      )
    )
  end

  def set_session_climb
    return unless session_climbs_valid? && @boulder&.persisted?

    @session_climb = SessionClimb.find_by(
      boulder_id: @boulder.id,
      session_id: boulder_params[:session_climbs_attributes][0][:session_id]
    )
  end
end