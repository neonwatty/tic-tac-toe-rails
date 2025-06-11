require 'test_helper'
$LOAD_PATH.unshift(Rails.root.join('app/services'))
require 'tic_tac_toe/ai_player'

class TicTacToe::AiPlayerTest < ActiveSupport::TestCase
  def setup
    @ai = TicTacToe::AiPlayer.new(difficulty: :easy)
    @empty_board = Array.new(3) { Array.new(3) }
    @partial_board = [
      ['X', nil, 'O'],
      [nil, 'X', nil],
      ['O', nil, nil]
    ]
  end

  test "initializes with difficulty" do
    assert_equal :easy, @ai.difficulty
  end

  test "valid_moves returns all empty cells" do
    assert_equal 9, @ai.valid_moves(@empty_board).size
    assert_equal [[0,1],[1,0],[1,2],[2,1],[2,2]], @ai.valid_moves(@partial_board)
  end

  test "choose_move returns a valid move" do
    move = @ai.choose_move(@partial_board, 'O')
    assert_includes @ai.valid_moves(@partial_board), move
  end

  test "AI blocks opponent's win" do
    # Player X is about to win at [0,2], AI O cannot win
    board = [
      ['X', 'X', nil],
      [nil, 'O', nil],
      [nil, nil, nil]
    ]
    move = @ai.choose_move(board, 'O')
    assert_equal [0,2], move
  end

  test "AI takes win if available" do
    # AI O can win at [1,2]
    board = [
      ['X', 'X', nil],
      ['O', 'O', nil],
      [nil, nil, nil]
    ]
    move = @ai.choose_move(board, 'O')
    # O can win at [1,2]
    assert_equal [1,2], move
  end
end 