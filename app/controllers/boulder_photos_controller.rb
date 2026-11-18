# frozen_string_literal: true

class BoulderPhotosController < ApplicationController
  before_action :get_boulder

  def index
    @editable = current_user == @boulder.created_by
  end

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
      render json: @boulder_photo.as_json.merge(
        image_url: rails_blob_url(
          @boulder_photo.image,
          host: request.host_with_port,
          protocol: 'http'
        )
      ), status: :created
    else
      render json: { errors: @boulder_photo.errors.as_json(full_messages: true) }, status: :unprocessable_entity
    end
  end


  private

  def photo_params
    params.require(:boulder_photo).permit(:caption, :image)
  end

  def get_boulder
    @boulder = Boulder.find(params[:boulder_id])
    render json: { error: "No boulder with that id" }, status: :not_found and return unless @boulder.present?
  end
end