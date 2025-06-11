require 'test_helper'
$LOAD_PATH.unshift(Rails.root.join('app/services'))
require 'tic_tac_toe/board'

class TicTacToe::BoardTest < ActiveSupport::TestCase
  def setup
    @board = TicTacToe::Board.new
  end

  test "initializes as empty 3x3 grid" do
    assert_equal 3, @board.grid.size
    assert @board.grid.all? { |row| row.size == 3 && row.all?(&:nil?) }
  end

  test "can set and get cell values" do
    @board[0, 0] = 'X'
    @board[1, 1] = 'O'
    assert_equal 'X', @board[0, 0]
    assert_equal 'O', @board[1, 1]
    assert_nil @board[2, 2]
  end

  test "serializes to flat array and back" do
    @board[0, 0] = 'X'
    @board[1, 1] = 'O'
    flat = @board.to_flat_array
    new_board = TicTacToe::Board.new(flat)
    assert_equal @board.to_a, new_board.to_a
  end

  test "reset clears the board" do
    @board[0, 0] = 'X'
    @board.reset!
    assert @board.grid.flatten.all?(&:nil?)
  end

  test "full? returns true when board is full" do
    3.times { |r| 3.times { |c| @board[r, c] = 'X' } }
    assert @board.full?
  end

  test "full? returns false when board is not full" do
    @board[0, 0] = 'X'
    refute @board.full?
  end
end 