class MatchesController < ApplicationController
  before_action :set_user, only: [:create, :index]
  before_action :set_match, only: [:show]

  # GET /users/:user_id/matches
  def index
    if @user
      response = @user.matches.map { |m| match_response(m)}
      render json: response, status: :ok
    else
      render json: {"Error": "User with id: #{params[:user_id]} does not exist"}, status: :not_found
    end
  end

  # GET /matches/1
  def show
    response = match_response(@match)
    render json: response
  end

  # POST /users/:user_id/matches
  def create
    cantor_identifier = match_params["cantor_identifier"]
    existing_match = Match.find_by(cantor_identifier: cantor_identifier)

    if existing_match
      existing_match.is_match = true
      existing_match.save
      render json: match_response(existing_match), status: :ok
      return
    else
      right_id = params["right_user_id"]

      match = Match.new
      match.cantor_identifier = generate_cantor(@user.id, right_id)
      add_users_to_match(right_id, match)

      if match.save
        render json: match_response(match), status: :created
      else
        render json: match.errors, status: :unprocessable_entity
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    def set_user
      @user = User.find_by_id(params[:user_id])
    end

    def generate_cantor(x,y)
      if x < y
        return (x * y) + ((x - y + 1) ** 2) / 4
      else
        return (x * y) + ((y - x + 1) ** 2) / 4
      end
    end

    def broadcast_match(match)
      ActionCable.server.broadcast 'matches',
        match: "RECIEVING MATCH BROADCAST",
      head: ok
    end

    def match_response(match)
      return {
        "id" => match.id,
        "created_at" => match.created_at,
        "updated_at" => match.updated_at,
        "cantor_identifier" => match.cantor_identifier,
        "is_match" => match.is_match,
        "users" => match.users
      }
    end

    def add_users_to_match(right_id, match)
      right_user = User.find_by_id(right_id)

      match.users << @user
      match.users << right_user
      return
    end

    # Only allow a trusted parameter "white list" through.
    def match_params
      params.permit(
        :right_user_id,
        :cantor_identifier
      )
    end
end
