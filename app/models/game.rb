class Game < ApplicationRecord
  belongs_to :player1, class_name: 'User'
  belongs_to :player2, class_name: 'User', optional: true

  enum :status, { in_progress: 0, completed: 1 }, validate: true

  validates :player1, presence: true
  # Allow moves to be blank (an empty array is valid for a new game)
  # validates :moves, presence: true

  BOARD_SIZE = 3

  # Returns the board as a 2D array
  def board
    arr = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    (moves || []).each do |move|
      arr[move["row"]][move["col"]] = move["symbol"]
    end
    arr
  end

  # Returns the symbol for the current player ("X" or "O")
  def current_player
    return "X" if moves.blank? || moves.size.even?
    "O"
  end

  # Returns the winner symbol ("X", "O", or nil)
  def winner
    b = board
    # Check rows, columns, and diagonals
    (0...BOARD_SIZE).each do |i|
      return b[i][0] if b[i][0].present? && b[i][0] == b[i][1] && b[i][1] == b[i][2]
      return b[0][i] if b[0][i].present? && b[0][i] == b[1][i] && b[1][i] == b[2][i]
    end
    return b[0][0] if b[0][0].present? && b[0][0] == b[1][1] && b[1][1] == b[2][2]
    return b[0][2] if b[0][2].present? && b[0][2] == b[1][1] && b[1][1] == b[2][0]
    nil
  end

  # Makes a move for the given user at (row, col)
  def make_move(user, row, col)
    return false unless status == "in_progress"
    return false unless valid_move?(user, row, col)
    self.moves ||= []
    self.moves << { "row" => row, "col" => col, "symbol" => player_symbol(user) }
    if winner.present?
      self.status = :completed
      self.result = winner
    elsif board.flatten.compact.size == BOARD_SIZE * BOARD_SIZE
      self.status = :completed
      self.result = "draw"
    end
    true
  end

  # Checks if the move is valid
  def valid_move?(user, row, col)
    return false unless (0...BOARD_SIZE).cover?(row) && (0...BOARD_SIZE).cover?(col)
    return false unless board[row][col].nil?
    player_symbol(user) == current_player
  end

  # Returns the symbol for the given user
  def player_symbol(user)
    user == player1 ? "X" : "O"
  end
end
