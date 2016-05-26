require 'spec_helper'

# Test params for a new game
def game_params(home_team, away_team)
  {:home_team_id => home_team.id, :away_team_id => away_team.id,
    :attendance => 45000, :stadium_name => "", :home_lineup => "",
    :away_lineup => "", :home_atbats => "", :home_runs_scored => "",
    :home_hits => "", :home_doubles => "", :home_triples => "",
    :home_home_runs => "", :home_RBI => "", :home_walks => "",
    :home_strikeouts => "", :home_stolen_bases => "", :home_caught_stealing => "",
    :home_errors => "", :home_assists => "", :home_putouts => "",
    :home_chances => "", :away_atbats => "", :away_runs_scored => "",
    :away_hits => "", :away_doubles => "", :away_triples => "",
    :away_home_runs => "", :away_RBI => "", :away_walks => "",
    :away_strikeouts => "", :away_stolen_bases => "", :away_caught_stealing => "", :away_errors => "",
    :away_assists => "", :away_putouts => "", :away_chances => "",
    :home_pitchers => "", :away_pitchers => "", :home_outs_recorded => "",
    :home_hits_allowed => "", :home_runs_allowed => "", :home_earned_runs_allowed => "",
    :home_walks_allowed => "", :home_strikeouts_recorded => "",
    :home_home_runs_allowed => "", :home_total_pitches => "",
    :home_strikes_thrown => "", :home_balls_thrown => "",
    :home_intentional_walks_allowed => "", :away_outs_recorded => "",
    :away_hits_allowed => "", :away_runs_allowed => "", :away_earned_runs_allowed => "",
    :away_walks_allowed => "", :away_strikeouts_recorded => "",
    :away_home_runs_allowed => "", :away_total_pitches => "",
    :away_strikes_thrown => "", :away_balls_thrown => "",
    :away_intentional_walks_allowed => "", :player_of_the_game => "", :pbp => ""}
end

describe Game do
  team_one = FactoryGirl.create(:team_with_players)
  team_two = FactoryGirl.create(:team_with_players)
  game = Game.new(game_params(team_one, team_two))
  game.play
  game.save!
end
