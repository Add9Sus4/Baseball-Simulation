require 'test_helper'

class PitchTest < ActiveSupport::TestCase

  def setup
    @game = new_game
    @pitch = Pitch.new(@game.home_team.players[0], @game.away_team.players[0], 0, 0, @game.heat_maps)
  end

  test "Retrieve correct called strike percentage" do
    zone_id = 14
    pitcher_hand = "LEFT"
    batter_hand = "LEFT"
    balls = 0
    strikes = 0
    pitch_type = "CH"
    assert_equal 86, @pitch.determine_called_strike_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
  end

  test "Retrieve correct contact percentage" do
    zone_id = 54
    pitcher_hand = "LEFT"
    batter_hand = "LEFT"
    balls = 0
    strikes = 0
    pitch_type = "CH"
    assert_equal 27, @pitch.determine_contact_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
  end

  test "Retrieve correct swing percentage" do
    zone_id = 61
    pitcher_hand = "LEFT"
    batter_hand = "LEFT"
    balls = 0
    strikes = 0
    pitch_type = "CH"
    assert_equal 30, @pitch.determine_swing_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
  end

  test "Retrieve correct pitch location" do
    pitcher_hand = "LEFT"
    batter_hand = "LEFT"
    balls = 0
    strikes = 1
    pitch_type = "CH"
    random_between_0_and_1 = 0.01
    count = 1
    sum = 0
    # Get the sum of all pitch location values
    72.times do
      sum += @pitch.heat_maps[:pitch_locations].where(zone_id: count, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
      count = count + 1
    end

    assert_in_delta 76.4, sum, 0.00001
    assert_equal 1, @pitch.determine_location(0.001, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    assert_equal 3, @pitch.determine_location(0.01, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    assert_equal 48, @pitch.determine_location(0.5, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    assert_equal 72, @pitch.determine_location(0.999, pitcher_hand, batter_hand, balls, strikes, pitch_type)
  end

  test "Correct random distribution" do
    target_min = 17
    target_max = 103
    target_range = target_max - target_min
    target_mean = 28
    target_stdev = 20
    randomData = @game.generateDistribution(target_min, target_max, target_mean, target_stdev)

    # puts "Min: #{randomData.min}, max: #{randomData.max}, mean: #{@game.calculateMean(randomData)}, stdev: #{@game.calculateStDev(randomData)}"

    assert_operator target_max, :>=, randomData.max
    assert_operator target_min, :<=, randomData.min
    assert_in_delta target_mean, @game.calculateMean(randomData), target_range*0.01 # must be within 1% of target
    assert_in_delta target_stdev, @game.calculateStDev(randomData), target_range*0.01 # must be within 1% of target
  end

end
