class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :require_login

  # This will be used/called when we need authentication
  def require_login
    authorize_request || render_unauthorized("Access denied")
  end

  # Helper method to find the current_user in a request
  def current_user
    @current_user ||= authorize_request
  end

  # Renders an message when a user is unauthorized
  def render_unauthorized(message)
    errors = { errors: message }
    render json: errors, status: :unauthorized
  end

  private
  # Authenticate a user with token
  def authorize_request
    authenticate_with_http_token do |token, options|
      User.find_by(token: token)
    end
  end
end
