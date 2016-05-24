require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @game = new_game
  end

  test "Team has correct number of players" do
    assert_equal Team::MAX_PLAYERS, @game.home_team.players.count
    assert_equal Team::MAX_PLAYERS, @game.away_team.players.count
  end

end
