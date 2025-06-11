# require "application_system_test_case"
#
# class SinglePlayerGameFlowTest < ApplicationSystemTestCase
#   test "single player game flow increments stats" do
#     visit new_single_player_game_path
#     click_button "Start Game"
#
#     # Play moves until the game ends
#     start_time = Time.now
#     loop do
#       # If it's the player's turn, click the first available cell
#       clicked = false
#       3.times do |r|
#         3.times do |c|
#           btn_id = "cell-#{r}-#{c}"
#           if page.has_selector?("##{btn_id}")
#             btn = find("##{btn_id}")
#             unless btn[:disabled]
#               btn.click
#               # Wait for the page to reload and the game-over message to possibly appear
#               page.has_text?("You win!", wait: 0.5)
#               page.has_text?("AI wins!", wait: 0.5)
#               page.has_text?("It's a draw!", wait: 0.5)
#               save_and_open_page # Debug: open the HTML after each move
#               clicked = true
#               break
#             end
#           end
#         end
#         break if clicked
#       end
#       # Break if game over message appears
#       break if page.has_text?("You win!") || page.has_text?("AI wins!") || page.has_text?("It's a draw!")
#       raise "Timeout waiting for game to finish" if Time.now - start_time > 10 # 10 seconds
#     end
#
#     # Check that at least one stat incremented
#     wins = find(".bg-green-100").text[/\d+/].to_i
#     losses = find(".bg-red-100").text[/\d+/].to_i
#     draws = find(".bg-gray-100").text[/\d+/].to_i
#     assert wins > 0 || losses > 0 || draws > 0, "Expected at least one stat to increment, got: wins=#{wins}, losses=#{losses}, draws=#{draws}"
#   end
# end 