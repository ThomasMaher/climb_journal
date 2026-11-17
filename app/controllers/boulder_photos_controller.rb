# frozen_string_literal: true

class BoulderPhotosController < ApplicationController
  def create
    @boulder = Boulder.find(params[:boulder_id])
    render json: { error: "No boulder with that id" }, status: :not_found and return unless @boulder.present?
    render json: { error: "You are not authorized to add images to this boulder" }, status: :unauthorized and return unless current_user == @boulder.created_by

    @boulder_photo = BoulderPhoto.new(
      boulder: @boulder,
      user: current_user,
      caption: photo_params[:caption],
      image: photo_params[:image]
    )

    if @boulder_photo.save
      render json: @boulder_photo, status: :created
    else
      render json: { errors: @boulder_photo.errors.as_json(full_messages: true) }, status: :unprocessable_entity
    end
  end


  private

  def photo_params
    params.require(:boulder_photo).permit(:caption, :image)
  end
end