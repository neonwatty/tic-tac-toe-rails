require "test_helper"

class HighScoreTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @game = games(:one)
    @high_score = HighScore.new(user: @user, game: @game, score: 10, difficulty_level: "medium")
  end

  test "valid high_score is valid" do
    assert @high_score.valid?
  end

  test "requires user, game, score, and difficulty_level" do
    @high_score.user = nil
    assert_not @high_score.valid?
    @high_score.user = @user
    @high_score.game = nil
    assert_not @high_score.valid?
    @high_score.game = @game
    @high_score.score = nil
    assert_not @high_score.valid?
    @high_score.score = 10
    @high_score.difficulty_level = nil
    assert_not @high_score.valid?
  end

  test "score must be integer and >= 0" do
    @high_score.score = -1
    assert_not @high_score.valid?
    @high_score.score = 1.5
    assert_not @high_score.valid?
    @high_score.score = 0
    assert @high_score.valid?
  end

  test "associations work" do
    @high_score.save!
    assert_equal @user, @high_score.reload.user
    assert_equal @game, @high_score.reload.game
  end
end
