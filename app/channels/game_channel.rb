class GameChannel < ApplicationCable::Channel
  def subscribed
    # Stream from a game-specific stream (to be customized per game instance)
    stream_from "game_#{params[:game_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    # Handle data received from the client (e.g., moves, chat)
    # ActionCable.server.broadcast("game_", data) can be used for rebroadcasting
  end
end 