
# Load environment configuration
# Dotenv.load

class TokensController < ApplicationController

  def index
    # Load environment configuration
    Dotenv.load
    identity = token_params[:identity]
    room = token_params[:room]
    # Grant access to Video
    video_grant = Twilio::JWT::AccessToken::VideoGrant.new()
    video_grant.room = room

    token = Twilio::JWT::AccessToken.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_API_KEY'],
      ENV['TWILIO_API_SECRET'],
      [video_grant],
      identity: identity
    )

    render json: {"token": token.to_jwt()}, status: :created
  end

  private
  def token_params
    params.permit(
      :identity,
      :room
    )
  end
end
