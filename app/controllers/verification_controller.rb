require "authy"

class VerificationController < ApplicationController
  skip_before_action :require_login

  def code
    phone_number = params[:phone_number]
    country_code = params[:country_code]
    via = params[:via]

    if !phone_number || !country_code || !via
      render json: { error: 'Missing fields' }, status: :internal_server_error and return
    end

    response = Authy::PhoneVerification.start(
      via: via,
      country_code: country_code,
      phone_number: phone_number,
      code_length: 5
    )

    if ! response.ok?
      render json: { error: 'Error delivering code verification' }, status: :internal_server_error and return
    end

    render json: response, status: :ok
  end

  def verify
    phone_number = params[:phone_number]
    country_code = params[:country_code]
    verification_code = params[:verification_code]

    if !phone_number || !country_code || !verification_code
      render json: { error: 'Missing fields' }, status: :internal_server_error and return
    end

    response = Authy::PhoneVerification.check(
      verification_code: verification_code,
      country_code: country_code,
      phone_number: phone_number
    )

    render json: response, status: :ok
  end

  private

  def auth_params
    params.permit(
      :phone_number,
      :country_code,
      :via,
      :verification_code
    )
  end
end
