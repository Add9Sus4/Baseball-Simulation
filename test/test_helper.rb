ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Logs in a test user
  def log_in_as(user, options = {})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email: user.email,
                                  password: password,
                                  remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

  # Creates a new game
  def new_game
    game = Game.new(game_params)
    game.prepare

    # set positions (for tests)
    game.home_team.update_attribute(:catcher, game.home_team.players[0].id)
    game.home_team.update_attribute(:designated_hitter, game.home_team.players[1].id)
    game.home_team.update_attribute(:first_base, game.home_team.players[2].id)
    game.home_team.update_attribute(:second_base, game.home_team.players[3].id)
    game.home_team.update_attribute(:third_base, game.home_team.players[4].id)
    game.home_team.update_attribute(:shortstop, game.home_team.players[5].id)
    game.home_team.update_attribute(:left_field, game.home_team.players[6].id)
    game.home_team.update_attribute(:center_field, game.home_team.players[7].id)
    game.home_team.update_attribute(:right_field, game.home_team.players[8].id)
    game.away_team.update_attribute(:catcher, game.away_team.players[0].id)
    game.away_team.update_attribute(:designated_hitter, game.away_team.players[1].id)
    game.away_team.update_attribute(:first_base, game.away_team.players[2].id)
    game.away_team.update_attribute(:second_base, game.away_team.players[3].id)
    game.away_team.update_attribute(:third_base, game.away_team.players[4].id)
    game.away_team.update_attribute(:shortstop, game.away_team.players[5].id)
    game.away_team.update_attribute(:left_field, game.away_team.players[6].id)
    game.away_team.update_attribute(:center_field, game.away_team.players[7].id)
    game.away_team.update_attribute(:right_field, game.away_team.players[8].id)

    game
  end

  # Test params for a new game
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
      :away_intentional_walks_allowed => "", :player_of_the_game => ""}
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end

  # Add more helper methods to be used by all tests here...
end
