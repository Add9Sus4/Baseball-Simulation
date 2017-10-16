require 'spec_helper'

# describe Bases do
#
#   before do
#     @away_team = FactoryGirl.create(:team_with_players)
#     @home_team = FactoryGirl.create(:team_with_players)
#     @bases = Bases.new(InningStatus::TOP, 1, @home_team, @away_team)
#   end
#
#   it "should initially have no runners on base" do
#     expect(@bases.runner_on_first).to be_nil
#     expect(@bases.runner_on_second).to be_nil
#     expect(@bases.runner_on_third).to be_nil
#   end
#
#   it "should initially have runs scored of 0" do
#     expect(@bases.runs_scored).to equal(0)
#   end
#
#   it "should initially have a base status of empty" do
#     expect(@bases.status).to equal(BaseStatus::EMPTY)
#   end
#
#   describe "#getRunsScored" do
#     it "should return the number of runs scored" do
#       @bases.runs_scored = 3
#       expect(@bases.getRunsScored).to equal(3)
#     end
#   end
#
# end

def test_speed(speed, home_team, away_team, bases)

  baserunner = away_team.players[0]
  pitcher = home_team.players[0]
  batter = away_team.players[1]

  baserunner.speed = speed
  baserunner.game_stolen_bases = 0
  num_atbats = 1000

  puts "\nsimulating #{num_atbats} at-bats with the following conditions:"
  puts "speed of runner on first: #{speed}"

  num_atbats.times do
    bases.updateStatusOnWalkOrHBP(baserunner, pitcher)
    atbat = AtBat.new(pitcher, batter, bases)
    bases.clear
  end

  puts "stolen bases: #{baserunner.game_stolen_bases} (#{baserunner.game_stolen_bases.to_f*100.0/1000.0}%)"
end

@home_team = FactoryGirl.create(:team_with_players)
@away_team = FactoryGirl.create(:team_with_players)
# put players on home team
@home_team.players.each do |player|
  player.set_initial_stats
end

# put players on away team
@away_team.players.each do |player|
  player.set_initial_stats
end
@bases = Bases.new(InningStatus::TOP, 1, @home_team, @away_team)

test_speed(100, @home_team, @away_team, @bases)
test_speed(50, @home_team, @away_team, @bases)
test_speed(0, @home_team, @away_team, @bases)
