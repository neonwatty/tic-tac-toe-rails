require "test_helper"

class GameTest < ActiveSupport::TestCase
  setup do
    @user1 = users(:one)
    @user2 = users(:two)
    @game = Game.new(player1: @user1, player2: @user2, moves: [], status: :in_progress)
  end

  test "initial board is empty" do
    assert_equal Array.new(3) { Array.new(3) }, @game.board
  end

  test "current_player alternates between X and O" do
    assert_equal "X", @game.current_player
    @game.moves << { "row" => 0, "col" => 0, "symbol" => "X" }
    assert_equal "O", @game.current_player
    @game.moves << { "row" => 1, "col" => 1, "symbol" => "O" }
    assert_equal "X", @game.current_player
  end

  test "make_move only allows valid moves and updates board" do
    assert @game.make_move(@user1, 0, 0), "Player1 should be able to move first"
    assert_equal "X", @game.board[0][0]
    assert_not @game.make_move(@user1, 0, 0), "Cannot move to occupied cell"
    assert @game.make_move(@user2, 1, 1), "Player2 should be able to move next"
    assert_equal "O", @game.board[1][1]
    assert_not @game.make_move(@user2, 2, 2), "Player2 cannot move twice in a row"
  end

  test "winner detects row, column, and diagonal wins" do
    # Row win
    @game.moves = [
      { "row" => 0, "col" => 0, "symbol" => "X" },
      { "row" => 1, "col" => 0, "symbol" => "O" },
      { "row" => 0, "col" => 1, "symbol" => "X" },
      { "row" => 1, "col" => 1, "symbol" => "O" },
      { "row" => 0, "col" => 2, "symbol" => "X" }
    ]
    assert_equal "X", @game.winner

    # Column win
    @game.moves = [
      { "row" => 0, "col" => 0, "symbol" => "O" },
      { "row" => 0, "col" => 1, "symbol" => "X" },
      { "row" => 1, "col" => 0, "symbol" => "O" },
      { "row" => 1, "col" => 1, "symbol" => "X" },
      { "row" => 2, "col" => 0, "symbol" => "O" }
    ]
    assert_equal "O", @game.winner

    # Diagonal win
    @game.moves = [
      { "row" => 0, "col" => 0, "symbol" => "X" },
      { "row" => 0, "col" => 1, "symbol" => "O" },
      { "row" => 1, "col" => 1, "symbol" => "X" },
      { "row" => 0, "col" => 2, "symbol" => "O" },
      { "row" => 2, "col" => 2, "symbol" => "X" }
    ]
    assert_equal "X", @game.winner
  end

  test "draw is detected when board is full and no winner" do
    # Board before last move (no winner):
    # X | O | X
    # X | O | O
    # O | X | _
    @game.moves = [
      { "row" => 0, "col" => 0, "symbol" => "X" },
      { "row" => 0, "col" => 1, "symbol" => "O" },
      { "row" => 0, "col" => 2, "symbol" => "X" },
      { "row" => 1, "col" => 0, "symbol" => "X" },
      { "row" => 1, "col" => 1, "symbol" => "O" },
      { "row" => 1, "col" => 2, "symbol" => "O" },
      { "row" => 2, "col" => 0, "symbol" => "O" },
      { "row" => 2, "col" => 1, "symbol" => "X" }
    ]
    assert_nil @game.winner
    @game.status = :in_progress
    @game.result = nil
    # Last move fills the board, should result in draw
    assert @game.make_move(@user1, 2, 2)
    assert_equal "draw", @game.result
    assert_equal "completed", @game.status
  end

  test "valid_move? enforces turn order and cell occupation" do
    assert @game.valid_move?(@user1, 0, 0)
    @game.moves << { "row" => 0, "col" => 0, "symbol" => "X" }
    assert_not @game.valid_move?(@user2, 0, 0), "Cannot move to occupied cell"
    assert @game.valid_move?(@user2, 1, 1)
    assert_not @game.valid_move?(@user1, 1, 1), "Not player1's turn"
  end

  test "player_symbol returns correct symbol for each user" do
    assert_equal "X", @game.player_symbol(@user1)
    assert_equal "O", @game.player_symbol(@user2)
  end
end
