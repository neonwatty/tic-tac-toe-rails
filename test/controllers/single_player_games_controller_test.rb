require 'test_helper'

class SinglePlayerGamesControllerTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = true
  parallelize(workers: 1)

  test "starting a new game resets state and stats" do
    post single_player_game_path
    assert_redirected_to single_player_game_path
    follow_redirect!
    assert session[:single_player_game_state]
    assert session[:single_player_stats]
  end

  test "making a move updates the board and progresses the game" do
    post single_player_game_path
    follow_redirect!
    state = session[:single_player_game_state]
    # Make a move as X
    post single_player_game_path, params: { row: 0, col: 0 }
    assert_redirected_to single_player_game_path
    follow_redirect!
    state = session[:single_player_game_state]
    # The board should have X at [0,0] (flat array)
    assert_equal 'X', state['board'][0 * 3 + 0]
    # The game should still be in progress or completed
    assert_includes ['in_progress', 'completed', 'draw'], state['status'].to_s
  end
end 