module TicTacToe
  class GameState
    attr_reader :board, :current_player, :move_history, :status
    PLAYER_X = 'X'
    PLAYER_O = 'O'
    STATUS_IN_PROGRESS = :in_progress
    STATUS_COMPLETED = :completed
    STATUS_DRAW = :draw

    def initialize(board_state = nil, current_player = PLAYER_X, move_history = [])
      @board = Board.new(board_state)
      @current_player = current_player
      @move_history = move_history.dup
      @status = STATUS_IN_PROGRESS
      update_status!
    end

    # Make a move and update state; returns true if move was made
    def make_move(row, col)
      return false unless @status == STATUS_IN_PROGRESS
      return false unless @board.make_move(row, col, @current_player)
      @move_history << [row, col, @current_player]
      switch_player!
      update_status!
      true
    end

    # Undo the last move
    def undo_move
      return false if @move_history.empty?
      row, col, player = @move_history.pop
      @board[row, col] = Board::EMPTY_CELL
      @current_player = player
      update_status!
      true
    end

    # Reset the game
    def reset!
      @board.reset!
      @current_player = PLAYER_X
      @move_history.clear
      @status = STATUS_IN_PROGRESS
    end

    # Check if the game is over
    def over?
      @status != STATUS_IN_PROGRESS
    end

    # Return the winner ('X', 'O', or nil)
    def winner
      @board.winner
    end

    def to_h
      {
        board: @board.to_flat_array,
        current_player: @current_player,
        move_history: @move_history,
        status: @status
      }
    end

    def to_json(*args)
      to_h.to_json(*args)
    end

    def self.from_h(hash)
      new(hash[:board] || hash['board'], hash[:current_player] || hash['current_player'], hash[:move_history] || hash['move_history'] || [])
    end

    def self.from_json(json)
      from_h(JSON.parse(json))
    end

    private

    def switch_player!
      @current_player = (@current_player == PLAYER_X ? PLAYER_O : PLAYER_X)
    end

    def update_status!
      if @board.winner
        @status = STATUS_COMPLETED
      elsif @board.full?
        @status = STATUS_DRAW
      else
        @status = STATUS_IN_PROGRESS
      end
    end
  end
end 