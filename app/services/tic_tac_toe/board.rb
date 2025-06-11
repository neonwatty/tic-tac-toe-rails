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
  end
end 