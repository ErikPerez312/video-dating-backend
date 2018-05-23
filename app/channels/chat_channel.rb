class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_user:#{current_user.id}"
  end

  def unsubscribed
    delete_from_available_table(current_user)
  end

  def connect()
    # Add me to available user table based on gender
    if current_user.gender == 0
      available_man = AvailableMan.new
      available_man.user = current_user
      available_man.save
    elsif current_user.gender == 1
      available_woman = AvailableWoman.new
      available_woman.user = current_user
      available_woman.save
    end

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
      # Each user needs a token with their own identity
      my_twilio_token = twilio_token_with(current_user.token, room_name)
      partner_twilio_token = twilio_token_with(partner.token, room_name)

      # Remove users from Available Woman/Man table
      delete_from_available_table(current_user)
      delete_from_available_table(partner)

      # Notify myself of connection
      ActionCable.server.broadcast(
        "chat_user:#{current_user.id}",
        room_name: room_name,
        twilio_token: my_twilio_token
      )

      # Notify partner of connection
      ActionCable.server.broadcast(
        "chat_user:#{partner.id}",
        room_name: room_name,
        twilio_token: partner_twilio_token
      )
    elsif partner == ""
      # No user was found. Make myself available again incase it was made false
      current_user.is_available = true
      current_user.save
    end

  end

  private
  def twilio_token_with(identity, room)
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
    # creates unique number using users' ID
    if current_user.id < partner_id
      return "#{(current_user.id * partner_id) + ((current_user.id - partner_id + 1) ** 2) / 4}"
    end
    return "#{(current_user.id * partner_id) + ((partner_id - current_user.id + 1) ** 2) / 4}"
  end

  def delete_from_available_table(user)
    if user.gender == 0
      unavailable_user = AvailableMan.find_by(user: user)
      if unavailable_user
        unavailable_user.destroy
      end

      return
    end

    unavailable_user = AvailableWoman.find_by(user: user)
    if unavailable_user
      unavailable_user.destroy
    end
  end

  def available_users
    # Gender - MEN: 0, Women: 1, Seeking - Men: 1, Women: 2, Both: 3
    user_seeking = current_user.seeking

    if user_seeking == 1
      # User is interested in Men
      available_men = AvailableMan.where.not(user: current_user).order("created_at")
      return available_men
    elsif user_seeking == 2
      # User is interested in Women
      available_women = AvailableWoman.where.not(user: current_user).order("created_at")
      return available_women
    else
      # User is bi-sexual
      # User will be connected to most available gender
      available_men = AvailableMan.where.not(user: current_user).order("created_at")
      available_women = AvailableWoman.where.not(user: current_user).order("created_at")

      if available_men.length > available_women.length
        return available_men
      end
      return available_women
    end
  end
end
