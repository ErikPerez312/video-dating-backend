class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :require_login, only: [:create], raise: false

  # GET /users
  def index
    @users = User.all.map { |u| user_response(u)}
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user, only: [:first_name, :last_name, :gender, :phone_number, :age, :id, :token]
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, only: [:first_name, :last_name, :gender, :phone_number, :age, :id, :token], status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user, only: [:first_name, :last_name, :gender, :phone_number, :age, :id, :token]
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def user_response(user)
      return {
        :first_name => user.first_name,
        :last_name => user.last_name,
        :gender => user.gender,
        :phone_number => user.phone_number,
        :age => user.age,
        :id => user.id,
        :token => user.id,
        :profile_images => user.profile_images
      }
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(
        :first_name,
        :last_name,
        :gender,
        :phone_number,
        :age,
        :password
      )
    end
end
