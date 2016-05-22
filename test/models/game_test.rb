require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def game_params
    {:home_team_id => Team.first.id, :away_team_id => Team.last.id,
      :attendance => 45000, :stadium_name => "", :home_lineup => "",
      :away_lineup => "", :home_atbats => "", :home_runs_scored => "",
      :home_hits => "", :home_doubles => "", :home_triples => "",
      :home_home_runs => "", :home_RBI => "", :home_walks => "",
      :home_strikeouts => "", :home_stolen_bases => "", :home_caught_stealing => "",
      :home_errors => "", :home_assists => "", :home_putouts => "",
      :home_chances => "", :away_atbats => "", :away_runs_scored => "",
      :away_hits => "", :away_doubles => "", :away_triples => "",
      :away_home_runs => "", :away_RBI => "", :away_walks => "",
      :away_strikeouts => "", :away_caught_stealing => "", :away_errors => "",
      :away_assists => "", :away_putouts => "", :away_chances => "",
      :home_pitchers => "", :away_pitchers => "", :home_innings_pitched => "",
      :home_hits_allowed => "", :home_runs_allowed => "", :home_earned_runs_allowed => "",
      :home_walks_allowed => "", :home_strikeouts_recorded => "",
      :home_home_runs_allowed => "", :home_total_pitches => "",
      :home_strikes_thrown => "", :home_balls_thrown => "",
      :home_intentional_walks_allowed => "", :away_innings_pitched => "",
      :away_hits_allowed => "", :away_runs_allowed => "", :away_earned_runs_allowed => "",
      :away_walks_allowed => "", :away_strikeouts_recorded => "",
      :away_home_runs_allowed => "", :away_total_pitches => "",
      :away_strikes_thrown => "", :away_balls_thrown => "",
      :away_intentional_walks_allowed => "", :player_of_the_game => ""}
  end

  def setup
    @game = Game.new(game_params)
    @game.prepare
  end

  test "Team has correct number of players" do
    # puts "#{Team.count}"
    # Team.first.players.each do |player|
    #   puts "#{player}"
    # end
    assert_equal 13, Team.first.players.count
  end

  test "Retrieve correct called strike percentage" do
    zone_id = 14
    pitcher_hand = "LEFT"
    batter_hand = "LEFT"
    balls = 0
    strikes = 0
    pitch_type = "CH"

    assert_equal 86, @game.called_strike_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
  end

  test "Retrieve correct contact percentage" do
    zone_id = 54
    pitcher_hand = "LEFT"
    batter_hand = "LEFT"
    balls = 0
    strikes = 0
    pitch_type = "CH"
    assert_equal 27, @game.contact_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
  end

  test "Retrieve correct swing percentage" do
    zone_id = 61
    pitcher_hand = "LEFT"
    batter_hand = "LEFT"
    balls = 0
    strikes = 0
    pitch_type = "CH"
    assert_equal 30, @game.swing_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
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
      sum += PitchLocation.where(zone_id: count, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
      count = count + 1
    end

    assert_in_delta 76.4, sum, 0.00001
    assert_equal 1, @game.pitch_location(0.001, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    assert_equal 3, @game.pitch_location(0.01, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    assert_equal 48, @game.pitch_location(0.5, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    assert_equal 72, @game.pitch_location(0.999, pitcher_hand, batter_hand, balls, strikes, pitch_type)
  end

end
