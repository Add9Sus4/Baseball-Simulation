require 'test_helper'

class AtBatTest < ActiveSupport::TestCase

  def setup
    @game = new_game
  end

  test "at-bat test" do
    atBat = @game.atBat
    play = Play.new(atBat)
    if atBat.result == AtBatResult::WALK
      assert_equal 3, atBat.balls
    elsif atBat.result == AtBatResult::STRIKEOUT
      assert_equal 2, atBat.strikes
    end
    assert true, atBat.over
  end
  
end
