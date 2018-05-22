class ChatChannel < ApplicationCable::Channel
  def subscribed
    if current_user.gender = 0
      available_man = AvailableMan.new
      available_man.user = current_user
      available_man.save
    elsif current_user.gender = 1
      available_woman = AvailableWoman.new
      available_woman.user = current_user
      available_woman.save
    end
    stream_from "chat_user:#{current_user.id}"
  end

  def unsubscribed
    if current_user.gender = 0
      user = AvailableMan.find_by(user: current_user)
      user.destroy
    elsif current_user.gender = 1
      user = AvailableWoman.find_by(user: current_user)
      user.destroy
    end
  end

  def connect(data)
    solo_users = available_users()
    partner = ""

    # Check every available user until I find another user thats available
    solo_users.each_with_index do |item ,index|
      possible_partner = item.user

      if possible_partner.is_available == true && current_user.is_available == true
        # We make possible_partner not available to reserve them
        possible_partner.is_available = false
        possible_partner.save
        partner = possible_partner

        current_user.is_available = false
        current_user.save
        break
      end
    end

    # Broadcast room info if a user was found
    if partner != ""
      room_name = room_name_with(partner.id)
      twilio_token = twilio_token_with(data["identity"], partner.id, room_name)

      # Notify myself of connection
      ActionCable.server.broadcast(
        "chat_user:#{current_user.id}",
        room_name: room_name,
        twilio_token: twilio_token
      )

      # Notify partner of connection
      ActionCable.server.broadcast(
        "chat_user:#{partner.id}",
        room_name: room_name,
        twilio_token: twilio_token
      )
    elsif partner == ""
      # No user was found. Make myself available again incase it was made false
      current_user.is_available = true
      current_user.save
    end

  end

  private
  def twilio_token_with(identity, partner_id, room)
    # Load environment configuration
    Dotenv.load
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
    return token.to_jwt()
  end

  def room_name_with(partner_id)
    if current_user.id < partner_id
      return (current_user.id * partner_id) + ((current_user.id - partner_id + 1) ** 2) / 4
    end
    return (current_user.id * partner_id) + ((partner_id - current_user.id + 1) ** 2) / 4
  end

  def available_users
    # Gender - MEN: 0, Women: 1, Seeking - Men: 1, Women: 2, Both: 3
    user_seeking = current_user.seeking

    if user_seeking == 1
      # User is interested in Men
      puts "men"
      available_men = AvailableMan.where.not(user: current_user).order("created_at")
      return available_men
    elsif user_seeking == 2
      # User is interested in Women
      puts "women"
      available_women = AvailableWoman.where.not(user: current_user).order("created_at")
      return available_women
    else
      # User is bi-sexual
      # User will be connected to most available gender
      puts "bi"
      available_men = AvailableMan.where.not(user: current_user).order("created_at")
      available_women = AvailableWoman.where.not(user: current_user).order("created_at")

      if available_men.length > available_women.length
        return available_men
      end
      return available_women
    end
  end
end
