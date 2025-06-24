class TwoPlayerGamesController < ApplicationController
  before_action :set_game, only: [:show, :move, :join]

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(player1: current_user, moves: [], status: :in_progress)
    if @game.save
      redirect_to two_player_game_path(@game)
    else
      flash.now[:alert] = @game.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def join
    if @game.player2.nil? && @game.player1 != current_user
      @game.update(player2: current_user)
    end
    redirect_to two_player_game_path(@game)
  end

  def show
    # Renders the two player game board
  end

  def move
    row = params[:row].to_i
    col = params[:col].to_i
    # Assume @game has a make_move method that takes the current user and coordinates
    if @game.make_move(current_user, row, col)
      @game.save
      ActionCable.server.broadcast("game_#{@game.id}", {
        board: @game.board.to_a,
        current_player: @game.current_player,
        status: @game.status,
        winner: @game.winner
      })
      redirect_to two_player_game_path(@game)
    else
      flash[:alert] = "Invalid move."
      redirect_to two_player_game_path(@game)
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end 