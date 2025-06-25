class SinglePlayerGamesController < ApplicationController
  allow_unauthenticated_access
  before_action :load_game_state, only: [:show, :create]
  before_action :load_stats, only: [:show, :create]

  def new
    # Just render the start screen
  end

  def show
    # Renders the game board and state as a full page
  end

  def create
    if params[:row] && params[:col]
      load_game_state
      row = params[:row].to_i
      col = params[:col].to_i
      Rails.logger.debug "[DEBUG] Before human move: #{ @game_state.to_h.inspect }"
      if @game_state.status == :in_progress && @game_state.current_player == 'X'
        @game_state.make_move(row, col)
        Rails.logger.debug "[DEBUG] After human move: #{ @game_state.to_h.inspect }"
        # AI move if game still in progress
        if @game_state.status == :in_progress && @game_state.current_player == 'O'
          ai = TicTacToe::AiPlayer.new(difficulty: :easy)
          ai_move = ai.choose_move(@game_state.board.to_a, 'O')
          Rails.logger.debug "[DEBUG] AI move chosen: #{ ai_move.inspect }"
          @game_state.make_move(*ai_move) if ai_move
          Rails.logger.debug "[DEBUG] After AI move: #{ @game_state.to_h.inspect }"
        end
      end
      update_stats_if_game_over
      save_game_state
      Rails.logger.debug "[DEBUG] After save_game_state: #{ session[:single_player_game_state].inspect }"
      redirect_to single_player_game_path
    else
      reset_game_state
      redirect_to single_player_game_path
    end
  end

  private

  def load_game_state
    data = session[:single_player_game_state]
    if data.is_a?(Hash) && data.key?(:board)
      # Symbol keys (from Ruby session)
      @game_state = TicTacToe::GameState.new(data[:board], data[:current_player], data[:move_history])
    elsif data.is_a?(Hash) && data.key?('board')
      # String keys (from JSON session)
      @game_state = TicTacToe::GameState.new(data['board'], data['current_player'], data['move_history'])
    else
      @game_state = TicTacToe::GameState.new
      save_game_state
    end
  end

  def save_game_state
    session[:single_player_game_state] = @game_state.to_h
    Rails.logger.debug "[DEBUG] save_game_state: #{session[:single_player_game_state].inspect}"
  end

  def reset_game_state
    session.delete(:single_player_game_state)
  end

  def load_stats
    session[:single_player_stats] ||= { 'wins' => 0, 'losses' => 0, 'draws' => 0 }
    @stats = session[:single_player_stats]
  end

  def update_stats_if_game_over
    return unless @game_state.status == :completed || @game_state.status == :draw
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
    Rails.logger.debug "[DEBUG] update_stats_if_game_over: #{session[:single_player_stats].inspect}"
  end
end 