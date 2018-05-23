class SessionsController < ApplicationController
  skip_before_action :require_login

  # GET /sessions
  def index
    @user = User.authenticate(params[:phone_number], params[:password])

    if @user
      render json: @user, status: :ok
    else
      render json: {"error": "invalid credentials"}, status: :unauthorized
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def session_params
      params.permit(
        :phone_number,
        :password
      )
    end
end
