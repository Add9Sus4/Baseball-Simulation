# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'ffaker'
include Reusable
numUsers = 2 # How many users to add to database
numTeams = 5 # How many teams per division to add to database
numPlayersPerTeam = 13 # How many players on each team to add to database
numPitchersPerTeam = 12 # How many pitchers on each team to add to database
teams = []

# Create initial season
@season = Season.create!(current_date: Date.parse("1st April 2000"), year: 2000)

# Create "team" for draft players
Team.create!(name: "Draft")

# Create "team" for free agents
Team.create!(name: "Free Agents")

# Generate initial free agents
puts "Generating initial free agents..."
20.times do
  pitcher = completely_random_pitcher(2, false)
end
30.times do
  player = completely_random_player(2, false)
end

# Create initial user
User.create!(name: "Example User",
              email: "example@railstutorial.org",
              password: "foobar",
              password_confirmation: "foobar",
              admin: true,
              activated: true,
              activated_at: Time.zone.now,
              team_id: -1)

team_names = {
  "NL East city 0" => "Philadelphia",
  "NL East city 1" => "New York",
  "NL East city 2" => "Miami",
  "NL East city 3" => "Washington",
  "NL East city 4" => "Atlanta",

  "NL Central city 0" => "Cincinnati",
  "NL Central city 1" => "St. Louis",
  "NL Central city 2" => "Chicago",
  "NL Central city 3" => "Milwaukee",
  "NL Central city 4" => "Pittsburgh",

  "NL West city 0" => "Los Angeles",
  "NL West city 1" => "San Diego",
  "NL West city 2" => "Arizona",
  "NL West city 3" => "Colorado",
  "NL West city 4" => "San Francisco",

  "AL East city 0" => "New York",
  "AL East city 1" => "Boston",
  "AL East city 2" => "Tampa Bay",
  "AL East city 3" => "Baltimore",
  "AL East city 4" => "Toronto",

  "AL Central city 0" => "Cleveland",
  "AL Central city 1" => "Minnesota",
  "AL Central city 2" => "Detroit",
  "AL Central city 3" => "Chicago",
  "AL Central city 4" => "Kansas City",

  "AL West city 0" => "Anaheim",
  "AL West city 1" => "Oakland",
  "AL West city 2" => "Texas",
  "AL West city 3" => "Houston",
  "AL West city 4" => "Seattle",

  "NL East name 0" => "Phillies",
  "NL East name 1" => "Mets",
  "NL East name 2" => "Marlins",
  "NL East name 3" => "Nationals",
  "NL East name 4" => "Braves",

  "NL Central name 0" => "Reds",
  "NL Central name 1" => "Cardinals",
  "NL Central name 2" => "Cubs",
  "NL Central name 3" => "Brewers",
  "NL Central name 4" => "Pirates",

  "NL West name 0" => "Dodgers",
  "NL West name 1" => "Padres",
  "NL West name 2" => "Diamondbacks",
  "NL West name 3" => "Rockies",
  "NL West name 4" => "Giants",

  "AL East name 0" => "Yankees",
  "AL East name 1" => "Red Sox",
  "AL East name 2" => "Rays",
  "AL East name 3" => "Orioles",
  "AL East name 4" => "Blue Jays",

  "AL Central name 0" => "Indians",
  "AL Central name 1" => "Twins",
  "AL Central name 2" => "Tigers",
  "AL Central name 3" => "White Sox",
  "AL Central name 4" => "Royals",

  "AL West name 0" => "Angels",
  "AL West name 1" => "Athletics",
  "AL West name 2" => "Rangers",
  "AL West name 3" => "Astros",
  "AL West name 4" => "Mariners"
}

["NL", "AL"].each do |current_league|
  ["East", "Central", "West"].each do |current_division|
    # Create teams
    numTeams.times do |num|
      city = team_names["#{current_league} #{current_division} city #{num}"]
      name = team_names["#{current_league} #{current_division} name #{num}"]
      puts "Creating team #{num + 1} of 5 in the #{current_league + ' ' + current_division} division (#{city + ' ' + name})..."
      league = current_league
      division = current_division
      stadium = name + " " + ["Stadium","Field","Park","Coliseum","Center"].sample
      capacity = 45000
      newTeam = Team.create!(city: city,
      name: name,
      league: league,
      division: division,
      stadium: stadium,
      capacity: capacity,
      streak: 0,
      rotation_position: 1,
      user_id: -1,
      season_id: 1)
      teams.unshift(newTeam)
    end

    # Create players for each team
    teams.each_with_index do |team, index|
      puts "Creating position players for the #{team.city + ' ' + team.name}..."
      players = []
      numPlayersPerTeam.times do |num|
        newPlayer = completely_random_player(team.id, false)
        players.unshift(newPlayer)
      end

      # players[12].update_attribute(:current_position, "C")
      # players[11].update_attribute(:current_position, "DH")
      # players[10].update_attribute(:current_position, "1B")
      # players[9].update_attribute(:current_position, "2B")
      # players[8].update_attribute(:current_position, "3B")
      # players[7].update_attribute(:current_position, "SS")
      # players[6].update_attribute(:current_position, "LF")
      # players[5].update_attribute(:current_position, "CF")
      # players[4].update_attribute(:current_position, "RF")
      # players[3].update_attribute(:current_position, "BN")
      # players[2].update_attribute(:current_position, "BN")
      # players[1].update_attribute(:current_position, "BN")
      # players[0].update_attribute(:current_position, "BN")
      #
      # players[12].update_attribute(:lineup_position, 1)
      # players[11].update_attribute(:lineup_position, 2)
      # players[10].update_attribute(:lineup_position, 3)
      # players[9].update_attribute(:lineup_position, 4)
      # players[8].update_attribute(:lineup_position, 5)
      # players[7].update_attribute(:lineup_position, 6)
      # players[6].update_attribute(:lineup_position, 7)
      # players[5].update_attribute(:lineup_position, 8)
      # players[4].update_attribute(:lineup_position, 9)
      # players[3].update_attribute(:lineup_position, -1)
      # players[2].update_attribute(:lineup_position, -1)
      # players[1].update_attribute(:lineup_position, -1)
      # players[0].update_attribute(:lineup_position, -1)



      team.update(
      catcher: players[12].id,
      designated_hitter: players[11].id,
      first_base: players[10].id,
      second_base: players[9].id,
      third_base: players[8].id,
      shortstop: players[7].id,
      left_field: players[6].id,
      center_field: players[5].id,
      right_field: players[4].id,
      lineup1: "C",
      lineup2: "DH",
      lineup3: "1B",
      lineup4: "2B",
      lineup5: "3B",
      lineup6: "SS",
      lineup7: "LF",
      lineup8: "CF",
      lineup9: "RF",
      wins: 0,
      losses: 0,
      runs_scored: 0,
      runs_allowed: 0,
      schedule: "",
      static_id: team.id)
    end
    # Create pitchers for each team
    teams.each_with_index do |team, index|
      puts "Creating pitchers for the #{team.city + ' ' + team.name}..."
      pitchers = []
      numPitchersPerTeam.times do |num|
        newPitcher = completely_random_pitcher(team.id, false)
        pitchers.unshift(newPitcher)
      end

      team.update(
      sp1: pitchers[0].id,
      sp2: pitchers[1].id,
      sp3: pitchers[2].id,
      sp4: pitchers[3].id,
      sp5: pitchers[4].id,
      lr: pitchers[5].id,
      mr1: pitchers[6].id,
      mr2: pitchers[7].id,
      mr3: pitchers[8].id,
      su1: pitchers[9].id,
      su2: pitchers[10].id,
      cl: pitchers[11].id)
    end

    teams.clear

  end
end

# Reload the teams
@all_teams = Team.where("id > ?", 2)

# Optimize rosters (put the best players in the starting lineups)
@all_teams.each do |team|
  team.optimize_roster(@season.current_date)
end

# Create the schedules

TOTAL_HOME_TWO_GAME_SERIES = 1
TOTAL_HOME_THREE_GAME_SERIES = 21
TOTAL_HOME_FOUR_GAME_SERIES = 4

TOTAL_AWAY_TWO_GAME_SERIES = 1
TOTAL_AWAY_THREE_GAME_SERIES = 21
TOTAL_AWAY_FOUR_GAME_SERIES = 4

TOTAL_HOMESTANDS = 7
TOTAL_ROAD_TRIPS = 8

TOTAL_DIVISION_SERIES = 24
TOTAL_INTERDIVISION_SERIES = 20
TOTAL_INTERLEAGUE_SERIES = 8

# one off day every 3 series

@current_date = Date.parse("1st April 2000")

@series = Hash.new 0

@series["TWO_GAME"] = 2
@series["THREE_GAME"] = 42
@series["FOUR_GAME"] = 8
@series["DIVISION"] = 24
@series["INTERDIVISION"] = 20
@series["INTERLEAGUE"] = 8

def create_series(series_index, num_games, series_type, remaining_team_ids, current_date)

  team_id = remaining_team_ids.sample
  remaining_team_ids.delete(team_id)
  team = Team.find(team_id)
  # CREATE NEW SERIES
  # Home or away?
  home = [true, false].sample
  # Find opponent
  opponent_id = remaining_team_ids.sample
  remaining_team_ids.delete(opponent_id)
  # @possible_opponents = nil
  # case series_type
  # when "DIVISION"
  #   @possible_opponents = Team.where("league = ? and division = ? and id != ?", team.league, team.division, team.id)
  # when "INTERDIVISION"
  #   @possible_opponents = Team.where("league = ? and id != ?", team.league, team.id)
  # when "INTERLEAGUE"
  #   @possible_opponents = Team.where("league != ?", team.league)
  # end



  home_id = home ? team_id : opponent_id
  away_id = home ? opponent_id : team_id

  # Now, create games
  num_games.times do |game_num|

    game_params = {:home_team_id => home_id, :away_team_id => away_id,
      :sim_date => current_date + game_num, :season_id => 1}

    game = Game.new(game_params)

    # save the game
    game.save
  end


end

puts "Creating season schedule..."

52.times do |index|
  puts "Creating series #{index + 1} of 52..."

  # Array of remaining team ids (so that there are no duplicate games)
  remaining_team_ids = []

  @all_teams.each do |team|
    remaining_team_ids.push(team.id)
  end

  # Next, how many games in the series
  num_games = 0
  rand = Random.new.rand(@series["TWO_GAME"] + @series["THREE_GAME"] + @series["FOUR_GAME"])
  if rand < @series["TWO_GAME"] # Two game series
    num_games = 2
    @series["TWO_GAME"] -= 1
  elsif rand < @series["TWO_GAME"] + @series["THREE_GAME"] # Three game series
    num_games = 3
    @series["THREE_GAME"] -= 1
  else # Four game series
    num_games = 4
    @series["FOUR_GAME"] -= 1
  end

  # Next, vs. division, interdivision, or interleague?
  series_type = ""
  rand = Random.new.rand(@series["DIVISION"] + @series["INTERDIVISION"] + @series["INTERLEAGUE"])
  if rand < @series["DIVISION"] # Division opponent
    series_type = "DIVISION"
    @series["DIVISION"] -= 1
  elsif rand < @series["DIVISION"] + @series["INTERDIVISION"] # Interdivision opponent
    series_type = "INTERDIVISION"
    @series["INTERDIVISION"] -= 1
  else # Interleague opponent
    series_type = "INTERLEAGUE"
    @series["INTERLEAGUE"] -= 1
  end

  count = 0
  while remaining_team_ids.length > 0
    count += 1

    create_series(index, num_games, series_type, remaining_team_ids, @current_date)
  end

  @current_date += num_games

  # off day every 3 series
  if index % 3 == 0
    @current_date += 1
  end

end















# # Create the schedules
#
# # First, determine series lengths
# TOTAL_TWO_GAME_SERIES = 2
# TOTAL_THREE_GAME_SERIES = 38
# TOTAL_FOUR_GAME_SERIES = 11
#
# @two_game_series = 0
# @three_game_series = 0
# @four_game_series = 0
#
# def two_game_series_remaining
#     TOTAL_TWO_GAME_SERIES - @two_game_series
# end
#
# def three_game_series_remaining
#     TOTAL_THREE_GAME_SERIES - @three_game_series
# end
#
# def four_game_series_remaining
#     TOTAL_FOUR_GAME_SERIES - @four_game_series
# end
#
# # Array of series lengths (this will look like [4, 2, 3, 3, 2, 4, 3, etc...])
# @series_lengths = []
#
# def add_series
#     # determine length of new series
#     rand = Random.new.rand(two_game_series_remaining + three_game_series_remaining + four_game_series_remaining)
#     if rand < two_game_series_remaining
#         @series_lengths.push(2)
#         @two_game_series += 1
#     elsif rand < two_game_series_remaining + three_game_series_remaining
#         @series_lengths.push(3)
#         @three_game_series += 1
#     else
#         @series_lengths.push(4)
#         @four_game_series += 1
#     end
# end
#
# 51.times do
#     add_series
# end
#
# # @counts = Hash.new 0
#
# # @series_lengths.each do |series|
# #     @counts[series] += 1
# # end
#
# # puts @series_lengths
#
# # puts @counts
#
# # Next, determine matchups
# @all_teams = Team.where("id > ?", 2)
#
# # array of team ids
# @teams = []
#
# @all_teams.each do |team|
#   @teams.push(team.id)
# end
#
# # This maps
# @season_matchups = Hash.new 0
#
# # loops over each series
# 51.times do |index|
#
#     @matchups = Hash.new 0
#
#     # start with all the teams in the array
#     @current_series_teams = Array.new(@teams)
#
#     # remove 2 teams and match them up
#     15.times do
#         home_team = @current_series_teams.delete(@current_series_teams.sample)
#         away_team = @current_series_teams.delete(@current_series_teams.sample)
#         @matchups[home_team] = away_team
#         @matchups[away_team] = home_team
#     end
#
#     # this now matches a series index (0 to 50) with a map of team ids to opponent ids
#     @season_matchups[index] = @matchups
#
# end
#
# # Now, create the schedules
# @team_schedules = Hash.new 0
#
# # 30 teams, each of which needs a schedule
# 30.times do |index|
#
#   # # Current date
#   # @current_date = Date.parse("1st April 2000")
#
#     schedule = []
#
#     # loop over each series
#     51.times do |j|
#
#         # loop over each game in the series
#         @series_lengths[j].times do
#
#           # # Create the game object to store in the database. This will be updated
#           # # with stats once the game is actually played.
#           # game_params = {:home_team_id => home_team, :away_team_id => away_team,
#           # :sim_date => @current_date}
#           #
#           # @game = Game.new(game_params)
#
#             # add the opponent's id to the schedule
#             schedule.push(@season_matchups[j][@teams[index]])
#         end
#     end
#
#     # Now, put this into a hash that maps team id with the schedule (an array of opponent ids)
#     @team_schedules[@teams[index]] = schedule
# end
#
# # @team_schedules is a hash where the key is the team id (here, 0 to 29) and the value is an array of opponent team ids (0 to 29)
# # puts @team_schedules
#
# # Now, update the schedule in the database (this will end up as a string of comma-separated values)
# @all_teams.each do |team|
#   team.update(
#   schedule: @team_schedules[team.id].to_s.chop[1..-1])
# end
