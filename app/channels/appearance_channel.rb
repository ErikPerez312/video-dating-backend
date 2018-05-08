class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    # responsible for subscribing to and streaming matches that are broadcast to this channel.
    stream_from "appearance"
    current_user.is_online = true
    current_user.save

    broadcast_user_availability
  end

  def unsubscribed
    current_user.is_online = false
    current_user.is_available = false
    current_user.save

    broadcast_user_availability
  end

  def appear()
    # user is online and available again
    current_user.is_available = true
    current_user.save

    broadcast_user_availability
  end

  def away
    # User is online but not available
    current_user.is_available = false
    current_user.save

    broadcast_user_availability
  end

  private
  def broadcast_user_availability
    ActionCable.server.broadcast(
      'appearance',
      online_user_count: User.where(is_online: true).all.length,
      online_available_user_count: User.where(is_available: true).all.length
    )
  end
end
