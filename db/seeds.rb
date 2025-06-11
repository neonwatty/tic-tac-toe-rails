# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data for idempotency
HighScore.delete_all
Game.destroy_all
User.destroy_all

# Seed Users
users = [
  { username: 'alice', email_address: 'alice@example.com', password: 'password' },
  { username: 'bob', email_address: 'bob@example.com', password: 'password' },
  { username: 'carol', email_address: 'carol@example.com', password: 'password' },
  { username: 'dave', email_address: 'dave@example.com', password: 'password' }
]
user_records = users.map { |attrs| User.find_or_create_by!(username: attrs[:username]) { |u| u.email_address = attrs[:email_address]; u.password = attrs[:password] } }

# Seed Games
# Alice vs Bob (completed), Carol vs AI (in_progress), Dave no games
alice, bob, carol, dave = user_records

game1 = Game.create!(player1: alice, player2: bob, moves: [{"x"=>0,"y"=>0},{"x"=>1,"y"=>1}], result: 'alice_win', status: :completed, difficulty_level: 'medium')
game2 = Game.create!(player1: carol, player2: nil, moves: [{"x"=>0,"y"=>0}], result: nil, status: :in_progress, difficulty_level: 'easy')

# Seed HighScores
HighScore.create!(user: alice, game: game1, score: 1, difficulty_level: 'medium')
HighScore.create!(user: bob, game: game1, score: 0, difficulty_level: 'medium')
HighScore.create!(user: carol, game: game2, score: 0, difficulty_level: 'easy')
# Dave has no games or high scores
