module TicTacToe
  class Board
    SIZE = 3
    EMPTY_CELL = nil

    attr_reader :grid

    # Initialize with a 2D array or flat array, or empty board
    def initialize(state = nil)
      if state.is_a?(Array) && state.length == SIZE * SIZE
        @grid = state.each_slice(SIZE).to_a
      elsif state.is_a?(Array) && state.length == SIZE && state.all? { |row| row.is_a?(Array) && row.length == SIZE }
        @grid = state.map { |row| row.dup }
      else
        @grid = Array.new(SIZE) { Array.new(SIZE, EMPTY_CELL) }
      end
    end

    # Get value at (row, col)
    def [](row, col)
      @grid[row][col]
    end

    # Set value at (row, col)
    def []=(row, col, value)
      @grid[row][col] = value
    end

    # Check if a move is valid (in bounds and cell is empty)
    def valid_move?(row, col)
      row.between?(0, SIZE - 1) && col.between?(0, SIZE - 1) && @grid[row][col].nil?
    end

    # Attempt to make a move; returns true if successful, false otherwise
    def make_move(row, col, value)
      return false unless valid_move?(row, col)
      self[row, col] = value
      true
    end

    # Return board as a flat array for serialization
    def to_flat_array
      @grid.flatten
    end

    # Return board as a 2D array
    def to_a
      @grid.map(&:dup)
    end

    # Reset the board
    def reset!
      @grid = Array.new(SIZE) { Array.new(SIZE, EMPTY_CELL) }
    end

    # Check if the board is full
    def full?
      @grid.flatten.none?(&:nil?)
    end

    # Return 'X', 'O', or nil if there is a winner
    def winner
      # Check rows
      @grid.each do |row|
        return row[0] if row[0] && row.uniq.size == 1
      end
      # Check columns
      SIZE.times do |col|
        col_vals = @grid.map { |row| row[col] }
        return col_vals[0] if col_vals[0] && col_vals.uniq.size == 1
      end
      # Check diagonals
      diag1 = (0...SIZE).map { |i| @grid[i][i] }
      return diag1[0] if diag1[0] && diag1.uniq.size == 1
      diag2 = (0...SIZE).map { |i| @grid[i][SIZE - 1 - i] }
      return diag2[0] if diag2[0] && diag2.uniq.size == 1
      nil
    end
  end
end 