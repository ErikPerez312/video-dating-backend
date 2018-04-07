class ProfileImagesController < ApplicationController
  before_action :set_profile_image, only: [:show, :update, :destroy]

  # GET /users/:user_id/profile_images
  def index
    images = current_user.profile_images
    render json: images
  end

  # POST /users/:user_id/profile_images
  def create
    @profile_image = ProfileImage.new(profile_image_params)
    @profile_image.user = current_user

    if @profile_image.save
      render json: @profile_image, status: :created
    else
      render json: @profile_image.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/:user_id/profile_images/:id
  def update
    if @profile_image.update(profile_image_params)
      render json: @profile_image
    else
      render json: @profile_image.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/:user_id/profile_images/:id
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
      params.permit(:image_file)

    end
end
