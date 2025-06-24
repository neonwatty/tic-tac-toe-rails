require 'test_helper'

class SinglePlayerGamesControllerTest < ActionDispatch::IntegrationTest
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
    # The board should have X at [0,0]
    assert_equal 'X', state['board'][0][0]
    # The game should still be in progress or completed
    assert_includes ['in_progress', 'completed', 'draw'], state['status'].to_s
  end

  test "game completion updates some stat" do
    post single_player_game_path
    follow_redirect!
    move_count = 0
    loop do
      state = session[:single_player_game_state]
      stats = session[:single_player_stats]
      break if state['status'] == 'completed' || state['status'] == 'draw' || state['board'].nil?
      empty = []
      if state['board']
        state['board'].each_with_index { |row, r| row.each_with_index { |cell, c| empty << [r, c] if cell.nil? } }
        move = empty.first
        post single_player_game_path, params: { row: move[0], col: move[1] }
        assert_redirected_to single_player_game_path
        follow_redirect!
        move_count += 1
      end
    end
    state = session[:single_player_game_state]
    stats = session[:single_player_stats]
    unless state['status'] == 'completed' || state['status'] == 'draw'
      flunk "Game did not complete. Final status: \\#{state['status'].inspect}, board: \\#{state['board'].inspect}"
    end
    # At least one stat should have incremented
    assert stats.values.any? { |v| v > 0 }, "Expected at least one stat to increment, got: \\#{stats.inspect}"
  end
end 