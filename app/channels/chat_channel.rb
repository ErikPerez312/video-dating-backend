class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_user:#{current_user.id}"
  end

  def unsubscribed
    delete_from_available_table(current_user)
  end

  def connect()
    current_user.is_available = true
    current_user.save

    available_user = AvailableUser.find_by(user: current_user)

    if available_user.nil?
      available_user = AvailableUser.new
      available_user.user = current_user
      available_user.save
    end

    available_users = AvailableUser.where.not(user: current_user).order("created_at")
    remote_partner = ""

    available_users.each { |remote_available_user|
      possible_partner = remote_available_user.user

      if possible_partner.is_available && current_user.is_available
        remote_partner = possible_partner
        possible_partner.is_available = false
        possible_partner.save
        current_user.is_available = false
        current_user.save
        break
      end
    }

    if remote_partner != ""
      # Generate unique room identifier using ID
      room_name = generate_unique_roomname(current_user.id, remote_partner.id)
      # Each user needs a token with their own identity
      current_user_token = twilio_token_with(current_user.token, room_name)
      remote_partner_token = twilio_token_with(remote_partner.token, room_name)

      # Users are no longer available
      delete_from_available_table(current_user)
      delete_from_available_table(remote_partner)

      # Notify current_user of connection
      ActionCable.server.broadcast(
        "chat_user:#{current_user.id}",
        room_name: room_name,
        twilio_token: current_user_token,
        remote_user_id: "#{current_user.id}",
        remote_user_first_name: current_user.first_name,
        remote_user_profile_image_url: profile_image_url(current_user)
      )

      # Notify remote_partner of connection
      ActionCable.server.broadcast(
        "chat_user:#{remote_partner.id}",
        room_name: room_name,
        twilio_token: remote_partner_token,
        remote_user_id: "#{remote_partner.id}",
        remote_user_first_name: remote_partner.first_name,
        remote_user_profile_image_url: profile_image_url(remote_partner)
      )
    elsif remote_partner == ""
      # No user was found. Make 'current_user' available again incase it was made false
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

    def generate_unique_roomname(user1_id, user2_id)
      # creates unique number using users' ID
      if user1_id < user2_id
        return "#{(user1_id * user2_id) + ((user1_id - user2_id + 1) ** 2) / 4}"
      end
      return "#{(user1_id * user2_id) + ((user2_id - user1_id + 1) ** 2) / 4}"
    end

    def delete_from_available_table(user)
        user.is_available = false
        user.save
        unavailable_user = AvailableUser.find_by(user: user)
        if unavailable_user
          unavailable_user.destroy
        end

      end

    def profile_image_url(user)
      profile_image = user.profile_images.last
      if profile_image
        return profile_image.image_file.url()
      else
        return "No image"
      end
    end
end
