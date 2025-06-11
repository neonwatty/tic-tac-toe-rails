class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    login = params[:email_address].to_s.strip
    user = User.find_by(email_address: login) || User.find_by(username: login)
    if user && user.authenticate(params[:password])
      start_new_session_for user
      redirect_to new_single_player_game_path
    else
      redirect_to new_session_path, alert: "Try another username/email or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
