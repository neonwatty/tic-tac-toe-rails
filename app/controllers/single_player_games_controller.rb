class SinglePlayerGamesController < ApplicationController
  allow_unauthenticated_access
  before_action :load_game_state, only: [:show, :create]
  before_action :load_stats, only: [:show, :create]

  def new
    reset_game_state
    redirect_to single_player_game_path
  end

  def show
    # Renders the game board and state
  end

  def create
    row = params[:row].to_i
    col = params[:col].to_i
    player = @game_state.current_player
    if @game_state.status == :in_progress && @game_state.current_player == 'X'
      @game_state.make_move(row, col)
      # AI's turn if game still in progress
      if @game_state.status == :in_progress && @game_state.current_player == 'O'
        ai = TicTacToe::AiPlayer.new(difficulty: :easy)
        ai_move = ai.choose_move(@game_state.board.to_a, 'O')
        @game_state.make_move(*ai_move) if ai_move
      end
    end
    update_stats_if_game_over
    save_game_state
    redirect_to single_player_game_path
  end

  private

  def load_game_state
    if session[:single_player_game_state]
      @game_state = TicTacToe::GameState.from_h(session[:single_player_game_state])
    else
      @game_state = TicTacToe::GameState.new
      save_game_state
    end
  end

  def save_game_state
    session[:single_player_game_state] = @game_state.to_h
  end

  def reset_game_state
    session.delete(:single_player_game_state)
  end

  def load_stats
    session[:single_player_stats] ||= { 'wins' => 0, 'losses' => 0, 'draws' => 0 }
    @stats = session[:single_player_stats]
  end

  def update_stats_if_game_over
    return unless @game_state.status == :completed
    load_stats
    case @game_state.winner
    when 'X'
      @stats['wins'] += 1
    when 'O'
      @stats['losses'] += 1
    else
      @stats['draws'] += 1
    end
    session[:single_player_stats] = @stats
  end
end 