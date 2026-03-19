class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      if Rails.env.production?
        PushNotificationService.new(
          user: user,
          title: "Heyyo, theres a new login",
          body: "Someone logged in to your account at #{DateTime.now.utc.strftime("%B %e, %Y %H:%M UTC")}"
        ).call
      end
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
