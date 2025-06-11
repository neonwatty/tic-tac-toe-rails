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

  test "valid_move? returns true for empty cell in bounds" do
    assert @board.valid_move?(1, 1)
  end

  test "valid_move? returns false for out of bounds cell" do
    refute @board.valid_move?(-1, 0)
    refute @board.valid_move?(0, 3)
  end

  test "valid_move? returns false for occupied cell" do
    @board[0, 0] = 'X'
    refute @board.valid_move?(0, 0)
  end

  test "make_move only sets cell if valid and returns true, else false" do
    assert @board.make_move(0, 0, 'X')
    assert_equal 'X', @board[0, 0]
    refute @board.make_move(0, 0, 'O')
    refute @board.make_move(3, 3, 'O')
  end

  test "winner returns X for row win" do
    3.times { |c| @board[0, c] = 'X' }
    assert_equal 'X', @board.winner
  end

  test "winner returns O for column win" do
    3.times { |r| @board[r, 1] = 'O' }
    assert_equal 'O', @board.winner
  end

  test "winner returns X for diagonal win (\)" do
    3.times { |i| @board[i, i] = 'X' }
    assert_equal 'X', @board.winner
  end

  test "winner returns O for diagonal win (/)" do
    3.times { |i| @board[i, 2 - i] = 'O' }
    assert_equal 'O', @board.winner
  end

  test "winner returns nil if no winner" do
    @board[0, 0] = 'X'
    @board[0, 1] = 'O'
    @board[0, 2] = 'X'
    assert_nil @board.winner
  end
end 