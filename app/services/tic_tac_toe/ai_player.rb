module TicTacToe
  class AiPlayer
    attr_reader :difficulty

    def initialize(difficulty: :easy)
      @difficulty = difficulty.to_sym
    end

    # Main interface: returns [row, col] for the AI's move
    def choose_move(board, marker)
      case difficulty
      when :easy
        easy_move(board, marker)
      else
        raise NotImplementedError, "Unknown difficulty: #{difficulty}"
      end
    end

    # Returns an array of [row, col] pairs for all empty cells
    def valid_moves(board)
      moves = []
      3.times do |row|
        3.times do |col|
          moves << [row, col] if board[row][col].nil?
        end
      end
      moves
    end

    # Easy AI: win if possible, block if needed, else random
    def easy_move(board, marker)
      opponent = marker == 'X' ? 'O' : 'X'
      # 1. Win if possible
      win_move = find_winning_move(board, marker)
      return win_move if win_move
      # 2. Block opponent's win
      block_move = find_winning_move(board, opponent)
      return block_move if block_move
      # 3. Otherwise random
      moves = valid_moves(board)
      moves.sample
    end

    # Returns [row, col] if marker can win in one move, else nil
    def find_winning_move(board, marker)
      valid_moves(board).each do |row, col|
        dup = deep_dup_board(board)
        dup[row][col] = marker
        return [row, col] if winner_for_board(dup) == marker
      end
      nil
    end

    # Returns 'X', 'O', or nil for winner
    def winner_for_board(board)
      lines = []
      3.times { |i| lines << board[i] } # rows
      3.times { |i| lines << [board[0][i], board[1][i], board[2][i]] } # cols
      lines << [board[0][0], board[1][1], board[2][2]]
      lines << [board[0][2], board[1][1], board[2][0]]
      lines.each do |line|
        return line[0] if line[0] && line.uniq.size == 1
      end
      nil
    end

    def deep_dup_board(board)
      board.map { |row| row.dup }
    end
  end
end 