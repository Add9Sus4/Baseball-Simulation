require 'spec_helper'

def test_batter_attribute(attributes_hash, home_team, away_team)

  walks       = 0
  strikeouts  = 0

  batter = away_team.players[0]
  pitcher = home_team.players[0]

  batter.set_initial_stats # so that stats get reset before each test

  num_atbats = 1000

  puts "\nsimulating #{num_atbats} at-bats with the following conditions:"
  attributes_hash.each do |key, value|
    batter[key.to_sym] = value
    puts "batter #{key}: #{value}\n"
    # test_name << key << "_#{value}"
  end

  num_atbats.times do
    bases = Bases.new(InningStatus::TOP, 1, home_team, away_team)
    atBat = AtBat.new(pitcher, batter, bases)
    play = Play.new(atBat)
    if play.result == PlayResult::OUT # Play resulted in an out
      pitcher.records_out(1)
    else # Play did not result in an out
      if HitResult.is_a_single(play.hit_result)
        batter.hits_single
        pitcher.allows_hit
      elsif HitResult.is_a_double(play.hit_result)
        batter.hits_double
        pitcher.allows_hit
      elsif HitResult.is_a_triple(play.hit_result)
        batter.hits_triple
        pitcher.allows_hit
      elsif HitResult.is_a_home_run(play.hit_result)
        batter.hits_home_run
        pitcher.allows_hit
        pitcher.allows_home_run
      end
    end # End play
  end

  puts "walks: #{batter.game_walks} (#{batter.game_walks.to_f*100.0/batter.game_atbats.to_f}%)"
  puts "strikeouts: #{batter.game_strikeouts} (#{batter.game_strikeouts.to_f*100.0/batter.game_atbats.to_f}%)"
  puts "home runs: #{batter.game_home_runs} (#{batter.game_home_runs.to_f*100.0/batter.game_atbats.to_f}%)"
  puts "avg: #{batter.game_hits.to_f/batter.game_atbats.to_f}"
  obp = (batter.game_hits + batter.game_walks).to_f/(batter.game_atbats + batter.game_walks).to_f
  puts "obp: #{obp}"
  slg = (batter.game_hits - batter.game_doubles - batter.game_triples - batter.game_home_runs + 2 * batter.game_doubles + 3 * batter.game_triples + 4 * batter.game_home_runs).to_f/batter.game_atbats.to_f
  puts "slg: #{slg}"
  puts "ops: #{obp + slg}"

  # reset the attribute
  attributes_hash.each do |key, value|
    batter[key.to_sym] = 50
  end

end

def test_pitcher_attribute(attributes_hash, home_team, away_team)

  walks       = 0
  strikeouts  = 0

  batter  = away_team.players[0]
  pitcher = home_team.players[0]

  # so that stats get reset before each test
  batter.set_initial_stats

  num_atbats = 1000

  puts "\nsimulating #{num_atbats} at-bats with the following conditions:"
  attributes_hash.each do |key, value|
    pitcher[key.to_sym] = value
    puts "pitcher #{key}: #{value}\n"
    # test_name << key << "_#{value}"
  end

  num_atbats.times do
    bases = Bases.new(InningStatus::TOP, 1, home_team, away_team)
    atBat = AtBat.new(pitcher, batter, bases)
    play = Play.new(atBat)
    if play.result == PlayResult::OUT # Play resulted in an out
      pitcher.records_out(1)
    else # Play did not result in an out
      if HitResult.is_a_single(play.hit_result)
        batter.hits_single
        pitcher.allows_hit
      elsif HitResult.is_a_double(play.hit_result)
        batter.hits_double
        pitcher.allows_hit
      elsif HitResult.is_a_triple(play.hit_result)
        batter.hits_triple
        pitcher.allows_hit
      elsif HitResult.is_a_home_run(play.hit_result)
        batter.hits_home_run
        pitcher.allows_hit
        pitcher.allows_home_run
      end
    end # End play
  end

  puts "walks: #{batter.game_walks} (#{batter.game_walks.to_f*100.0/batter.game_atbats.to_f}%)"
  puts "strikeouts: #{batter.game_strikeouts} (#{batter.game_strikeouts.to_f*100.0/batter.game_atbats.to_f}%)"
  puts "home runs: #{batter.game_home_runs} (#{batter.game_home_runs.to_f*100.0/batter.game_atbats.to_f}%)"
  puts "avg: #{batter.game_hits.to_f/batter.game_atbats.to_f}"
  obp = (batter.game_hits + batter.game_walks).to_f/(batter.game_atbats + batter.game_walks).to_f
  puts "obp: #{obp}"
  slg = (batter.game_hits - batter.game_doubles - batter.game_triples - batter.game_home_runs + 2 * batter.game_doubles + 3 * batter.game_triples + 4 * batter.game_home_runs).to_f/batter.game_atbats.to_f
  puts "slg: #{slg}"
  puts "ops: #{obp + slg}"

  # reset the attribute
  attributes_hash.each do |key, value|
    pitcher[key.to_sym] = 50
  end

end


# Run the tests

# build the teams
home_team = FactoryGirl.create(:team_with_players)
away_team = FactoryGirl.create(:team_with_players)

# put players on home team
home_team.players.each do |player|
  player.set_initial_stats
end

# put players on away team
away_team.players.each do |player|
  player.set_initial_stats
end

# Test batter attributes
# test_batter_attribute({"patience" => 100}, home_team, away_team)
# test_batter_attribute({"patience" => 50}, home_team, away_team)
# test_batter_attribute({"patience" => 0}, home_team, away_team)
# test_batter_attribute({"plate_vision" => 100}, home_team, away_team)
# test_batter_attribute({"plate_vision" => 50}, home_team, away_team)
# test_batter_attribute({"plate_vision" => 0}, home_team, away_team)
# test_batter_attribute({"contact" => 100}, home_team, away_team)
# test_batter_attribute({"contact" => 50}, home_team, away_team)
# test_batter_attribute({"contact" => 0}, home_team, away_team)
# test_batter_attribute({"power" => 100}, home_team, away_team)
# test_batter_attribute({"power" => 50}, home_team, away_team)
# test_batter_attribute({"power" => 0}, home_team, away_team)
# test_batter_attribute({"uppercut_amount" => 100}, home_team, away_team)
# test_batter_attribute({"uppercut_amount" => 50}, home_team, away_team)
# test_batter_attribute({"uppercut_amount" => 0}, home_team, away_team)
# test_batter_attribute({"batting_average" => 100}, home_team, away_team)
# test_batter_attribute({"batting_average" => 50}, home_team, away_team)
# test_batter_attribute({"batting_average" => 0}, home_team, away_team)

# Test pitcher attributes
test_pitcher_attribute({"armStrength" => 100}, home_team, away_team)
test_pitcher_attribute({"armStrength" => 50}, home_team, away_team)
test_pitcher_attribute({"armStrength" => 0}, home_team, away_team)
test_pitcher_attribute({"movement" => 100}, home_team, away_team)
test_pitcher_attribute({"movement" => 50}, home_team, away_team)
test_pitcher_attribute({"movement" => 0}, home_team, away_team)

Team.delete_all
Player.delete_all
