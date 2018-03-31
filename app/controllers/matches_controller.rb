class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :update, :destroy]

  # GET /matches
  def index
    @matches = Match.all

    render json: @matches
  end

  # GET /matches/1
  def show
    render json: @match
  end

  # POST /matches
  def create
    @cantor_identifier = params["cantor_identifier"]
    @existing_match = Match.find_by(cantor_identifier: @cantor_identifier)

    if @existing_match
      @existing_match.is_match = true
      @existing_match.save
      render json: @existing_match, status: :ok
      return
    else
      @left_id = params["left_user_id"]
      @right_id = params["right_user_id"]

      @match = Match.new
      @match.cantor_identifier = generate_cantor(@left_id, @right_id)
      add_users_to_match(@left_id, @right_id, @match)

      if @match.save
        render json: @match, status: :created #, location: @match
      else
        render json: @match.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /matches/1
  def update
    if @match.update(match_params)
      render json: @match
    else
      render json: @match.errors, status: :unprocessable_entity
    end
  end

  # DELETE /matches/1
  def destroy
    @match.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    def generate_cantor(x,y)
      if x < y
        return (x * y) + ((x - y + 1) ** 2) / 4
      else
        return (x * y) + ((y - x + 1) ** 2) / 4
      end
    end

    def add_users_to_match(left_id, right_id, match)
      @left_user = User.find_by_id(left_id)
      @right_user = User.find_by_id(right_id)

      match.users << @left_user
      match.users << @right_user
      # match.save
      return
    end

    # Only allow a trusted parameter "white list" through.
    def match_params
      prams.permit(
        :left_user_id,
        :right_user_id,
        :cantor_identifier
      )
    end
end
