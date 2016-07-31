desc "This task is called by the Heroku scheduler add-on"
task :simulate_games => :environment do
  puts "Simulating games..."

  # hash to determine if a team has already played a game (to avoid duplicate games)
  @already_played_hash = Hash.new 0
  @game_number = Season.first.next_game

  Team.find_each do |team|
    unless @already_played_hash[team.id] == 1 then

      current_game_params = {:home_team_id => team.id, :away_team_id => schedule[@game_number],
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

      @game = Game.new(game_params)
      schedule = team.schedule.split(", ").map {|s| s.to_i} # array of opponent ids
      @game.away_team_id = schedule[@game_number] # Assume opponent is away team (this will be changed later)
      @game.home_team_id = team.id
      # Add both teams to list of already played teams
      @already_played_hash[schedule[@game_number]] = 1
      @already_played_hash[team.id] = 1
      @game.play
    end
  end

  # increment game number in season
  Season.first.update_attributes(next_game: Season.first.next_game + 1)

end
puts "done."
