require 'test_helper'

class InningTest < ActiveSupport::TestCase

  def setup
    @game = new_game
  end

  test "inning test" do
    inning = Inning.new(@game.away_team, @game.home_team, @game.heat_maps)
  end

end
