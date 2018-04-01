class SessionsController < ApplicationController
  skip_before_action :require_login

  # GET /sessions
  def index
    @user = User.authenticate(params[:phone_number], params[:password])

    if @user
      render json: @user, only: [:first_name, :last_name, :gender, :phone_number, :age, :id, :token], status: :ok
    else
      render json: {"error": "invalid credentials"}, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Session.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def session_params
      params.permit(
        :phone_number,
        :password
      )
    end
end
