require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  # setup do
  #   @game = games(:one)
  # end
  #
  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:games)
  # end
  #
  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end
  #
  # test "should create game" do
  #   assert_difference('Game.count') do
  #     post :create, game: { attendance: @game.attendance, away_RBI: @game.away_RBI, away_assists: @game.away_assists, away_atbats: @game.away_atbats, away_balls_thrown: @game.away_balls_thrown, away_caught_stealing: @game.away_caught_stealing, away_chances: @game.away_chances, away_doubles: @game.away_doubles, away_earned_runs_allowed: @game.away_earned_runs_allowed, away_errors: @game.away_errors, away_hits: @game.away_hits, away_hits_allowed: @game.away_hits_allowed, away_home_runs: @game.away_home_runs, away_home_runs_allowed: @game.away_home_runs_allowed, away_innings_pitched: @game.away_innings_pitched, away_intentional_walks_allowed: @game.away_intentional_walks_allowed, away_lineup: @game.away_lineup, away_pitchers: @game.away_pitchers, away_putouts: @game.away_putouts, away_runs_allowed: @game.away_runs_allowed, away_runs_scored: @game.away_runs_scored, away_strikeouts: @game.away_strikeouts, away_strikeouts_recorded: @game.away_strikeouts_recorded, away_strikes_thrown: @game.away_strikes_thrown, away_team_id: @game.away_team_id, away_total_pitches: @game.away_total_pitches, away_triples: @game.away_triples, away_walks: @game.away_walks, away_walks_allowed: @game.away_walks_allowed, home_RBI: @game.home_RBI, home_assists: @game.home_assists, home_atbats: @game.home_atbats, home_balls_thrown: @game.home_balls_thrown, home_caught_stealing: @game.home_caught_stealing, home_chances: @game.home_chances, home_doubles: @game.home_doubles, home_earned_runs_allowed: @game.home_earned_runs_allowed, home_errors: @game.home_errors, home_hits: @game.home_hits, home_hits_allowed: @game.home_hits_allowed, home_home_runs: @game.home_home_runs, home_home_runs_allowed: @game.home_home_runs_allowed, home_innings_pitched: @game.home_innings_pitched, home_intentional_walks_allowed: @game.home_intentional_walks_allowed, home_lineup: @game.home_lineup, home_pitchers: @game.home_pitchers, home_putouts: @game.home_putouts, home_runs_allowed: @game.home_runs_allowed, home_runs_scored: @game.home_runs_scored, home_stolen_bases: @game.home_stolen_bases, home_strikeouts: @game.home_strikeouts, home_strikeouts_recorded: @game.home_strikeouts_recorded, home_strikes_thrown: @game.home_strikes_thrown, home_team_id: @game.home_team_id, home_total_pitches: @game.home_total_pitches, home_triples: @game.home_triples, home_walks: @game.home_walks, home_walks_allowed: @game.home_walks_allowed, player_of_the_game: @game.player_of_the_game, stadium_name: @game.stadium_name }
  #   end
  #
  #   assert_redirected_to game_path(assigns(:game))
  # end
  #
  # test "should show game" do
  #   get :show, id: @game
  #   assert_response :success
  # end
  #
  # test "should get edit" do
  #   get :edit, id: @game
  #   assert_response :success
  # end
  #
  # test "should update game" do
  #   patch :update, id: @game, game: { attendance: @game.attendance, away_RBI: @game.away_RBI, away_assists: @game.away_assists, away_atbats: @game.away_atbats, away_balls_thrown: @game.away_balls_thrown, away_caught_stealing: @game.away_caught_stealing, away_chances: @game.away_chances, away_doubles: @game.away_doubles, away_earned_runs_allowed: @game.away_earned_runs_allowed, away_errors: @game.away_errors, away_hits: @game.away_hits, away_hits_allowed: @game.away_hits_allowed, away_home_runs: @game.away_home_runs, away_home_runs_allowed: @game.away_home_runs_allowed, away_innings_pitched: @game.away_innings_pitched, away_intentional_walks_allowed: @game.away_intentional_walks_allowed, away_lineup: @game.away_lineup, away_pitchers: @game.away_pitchers, away_putouts: @game.away_putouts, away_runs_allowed: @game.away_runs_allowed, away_runs_scored: @game.away_runs_scored, away_strikeouts: @game.away_strikeouts, away_strikeouts_recorded: @game.away_strikeouts_recorded, away_strikes_thrown: @game.away_strikes_thrown, away_team_id: @game.away_team_id, away_total_pitches: @game.away_total_pitches, away_triples: @game.away_triples, away_walks: @game.away_walks, away_walks_allowed: @game.away_walks_allowed, home_RBI: @game.home_RBI, home_assists: @game.home_assists, home_atbats: @game.home_atbats, home_balls_thrown: @game.home_balls_thrown, home_caught_stealing: @game.home_caught_stealing, home_chances: @game.home_chances, home_doubles: @game.home_doubles, home_earned_runs_allowed: @game.home_earned_runs_allowed, home_errors: @game.home_errors, home_hits: @game.home_hits, home_hits_allowed: @game.home_hits_allowed, home_home_runs: @game.home_home_runs, home_home_runs_allowed: @game.home_home_runs_allowed, home_innings_pitched: @game.home_innings_pitched, home_intentional_walks_allowed: @game.home_intentional_walks_allowed, home_lineup: @game.home_lineup, home_pitchers: @game.home_pitchers, home_putouts: @game.home_putouts, home_runs_allowed: @game.home_runs_allowed, home_runs_scored: @game.home_runs_scored, home_stolen_bases: @game.home_stolen_bases, home_strikeouts: @game.home_strikeouts, home_strikeouts_recorded: @game.home_strikeouts_recorded, home_strikes_thrown: @game.home_strikes_thrown, home_team_id: @game.home_team_id, home_total_pitches: @game.home_total_pitches, home_triples: @game.home_triples, home_walks: @game.home_walks, home_walks_allowed: @game.home_walks_allowed, player_of_the_game: @game.player_of_the_game, stadium_name: @game.stadium_name }
  #   assert_redirected_to game_path(assigns(:game))
  # end
  #
  # test "should destroy game" do
  #   assert_difference('Game.count', -1) do
  #     delete :destroy, id: @game
  #   end
  #
  #   assert_redirected_to games_path
  # end
end
