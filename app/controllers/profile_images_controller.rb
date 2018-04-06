class ProfileImagesController < ApplicationController
  before_action :set_profile_image, only: [:show, :update, :destroy]

  # GET /profile_images
  def index
    @profile_images = ProfileImage.all

    render json: @profile_images
  end

  # GET /profile_images/1
  def show
    render json: @profile_image
  end

  # POST /profile_images
  def create
    @profile_image = ProfileImage.new(profile_image_params)

    if @profile_image.save
      render json: @profile_image, status: :created, location: @profile_image
    else
      render json: @profile_image.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profile_images/1
  def update
    if @profile_image.update(profile_image_params)
      render json: @profile_image
    else
      render json: @profile_image.errors, status: :unprocessable_entity
    end
  end

  # DELETE /profile_images/1
  def destroy
    @profile_image.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_image
      @profile_image = ProfileImage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def profile_image_params
      params.permit(
        :image_file,
      )
    end
end
