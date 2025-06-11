class Game < ApplicationRecord
  belongs_to :player1, class_name: 'User'
  belongs_to :player2, class_name: 'User', optional: true

  enum :status, { in_progress: 0, completed: 1 }, validate: true

  validates :player1, presence: true
  validates :moves, presence: true
end
