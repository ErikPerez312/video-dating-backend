class MatchesChannel < ApplicationCable::Channel
  def subscribed
    # responsible for subscribing to and streaming matches that are broadcast to this channel.
    # users = User.all
    # stream_for users
    stream_from "matches"
  end
end
