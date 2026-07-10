class BouldersController < ApplicationController
  def index
    render json: {message: 'Coming soon.'}
  end

  def show
    boulder = Boulder.find(params[:id])

    render json: boulder
  end

  def create
    boulder = Boulder.new(boulder_params)

    if boulder.save
      render json: boulder, status: :created
    else
      render json: { errors: boulder.errors.as_json(full_messages: true) }, status: :unprocessable_entity
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
      :nickname
    )
  end
end