class HighScore < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :difficulty_level, presence: true
end
