class ChatsController < ApplicationController
  # before_action :set_chat, only: [:show, :update, :destroy]

  # GET /chats
  def index
    available_users = User.where(is_available: true).all

    if available_users
      render json: available_users
    else
      render json: {"Error": "No available users"}, status: :not_found
    end
  end

  # GET /chats/1
  def show
    user = random_available_user
    puts user
    if user
      render json: user
    else
      render json: {"Error": "No available users"}, status: :not_found
    end
  end

  private
    def random_available_user
      user_found = false
      while user_found == false
        available_users = User.where(is_available: true).all
        if available_users.length == 1
          # Only available user is the one making the request
          user_found = true
          return nil
        else
          random_user = available_users.sample
          if random_user.id != current_user.id
            user_found = true
            return random_user
          end
        end
      end
    end
end
