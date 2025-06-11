require 'test_helper'
$LOAD_PATH.unshift(Rails.root.join('app/services'))
require 'tic_tac_toe/board'
require 'tic_tac_toe/game_state'

class TicTacToe::GameStateTest < ActiveSupport::TestCase
  def setup
    @state = TicTacToe::GameState.new
  end

  test "initial state is empty board, X to move, in progress" do
    assert_equal Array.new(3) { Array.new(3) }, @state.board.to_a
    assert_equal 'X', @state.current_player
    assert_equal :in_progress, @state.status
    assert_empty @state.move_history
  end

  test "make_move applies move, switches player, and tracks history" do
    assert @state.make_move(0, 0)
    assert_equal 'X', @state.move_history.first.last
    assert_equal 'O', @state.current_player
    assert_equal 'X', @state.board[0, 0]
  end

  test "make_move returns false for invalid move or after game over" do
    @state.make_move(0, 0) # X
    @state.make_move(0, 1) # O
    @state.make_move(1, 0) # X
    @state.make_move(1, 1) # O
    @state.make_move(2, 0) # X (X wins)
    refute @state.make_move(2, 2) # game over
    refute @state.make_move(0, 0) # already occupied
  end

  test "undo_move reverts last move and player" do
    @state.make_move(0, 0)
    assert @state.undo_move
    assert_equal 'X', @state.current_player
    assert_nil @state.board[0, 0]
    assert_empty @state.move_history
  end

  test "reset! clears board, history, and sets X to move" do
    @state.make_move(0, 0)
    @state.reset!
    assert_equal Array.new(3) { Array.new(3) }, @state.board.to_a
    assert_equal 'X', @state.current_player
    assert_empty @state.move_history
    assert_equal :in_progress, @state.status
  end

  test "winner and status update after win or draw" do
    3.times { |i| @state.make_move(i, 0); @state.make_move(i, 1) }
    assert_equal 'X', @state.winner
    assert_equal :completed, @state.status
    @state.reset!
    moves = [[0,0],[0,1],[0,2],[1,1],[1,0],[1,2],[2,1],[2,0],[2,2]]
    moves.each { |r,c| @state.make_move(r, c) }
    assert_nil @state.winner
    assert_equal :draw, @state.status
  end

  test "to_h and from_h serialize and restore game state" do
    @state.make_move(0, 0)
    @state.make_move(1, 1)
    hash = @state.to_h
    restored = TicTacToe::GameState.from_h(hash)
    assert_equal @state.board.to_a, restored.board.to_a
    assert_equal @state.current_player, restored.current_player
    assert_equal @state.move_history, restored.move_history
    assert_equal @state.status, restored.status
  end

  test "to_json and from_json serialize and restore game state" do
    @state.make_move(0, 0)
    @state.make_move(1, 1)
    json = @state.to_json
    restored = TicTacToe::GameState.from_json(json)
    assert_equal @state.board.to_a, restored.board.to_a
    assert_equal @state.current_player, restored.current_player
    assert_equal @state.move_history, restored.move_history
    assert_equal @state.status, restored.status
  end

  test "cannot make move after draw" do
    moves = [[0,0],[0,1],[0,2],[1,1],[1,0],[1,2],[2,1],[2,0],[2,2]]
    moves.each { |r,c| @state.make_move(r, c) }
    assert_equal :draw, @state.status
    refute @state.make_move(0, 0)
  end

  test "undo after win reverts to in progress" do
    @state.make_move(0, 0) # X
    @state.make_move(0, 1) # O
    @state.make_move(1, 0) # X
    @state.make_move(1, 1) # O
    @state.make_move(2, 0) # X (X wins)
    assert_equal :completed, @state.status
    assert @state.undo_move
    assert_equal :in_progress, @state.status
    assert_nil @state.winner
  end

  test "O can win as well as X" do
    @state.make_move(0, 0) # X
    @state.make_move(0, 1) # O
    @state.make_move(1, 0) # X
    @state.make_move(1, 1) # O
    @state.make_move(2, 2) # X
    @state.make_move(2, 1) # O (O wins)
    assert_equal 'O', @state.winner
    assert_equal :completed, @state.status
  end

  test "serialization after undo and reset" do
    @state.make_move(0, 0)
    @state.make_move(1, 1)
    @state.undo_move
    hash = @state.to_h
    restored = TicTacToe::GameState.from_h(hash)
    assert_equal @state.board.to_a, restored.board.to_a
    @state.reset!
    json = @state.to_json
    restored2 = TicTacToe::GameState.from_json(json)
    assert_equal @state.board.to_a, restored2.board.to_a
    assert_equal @state.status, restored2.status
  end
end 