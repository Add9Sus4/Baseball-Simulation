desc "This task is called by the Heroku scheduler add-on"
def test_attribute(attributes_hash, game)

  @batter = FactoryGirl.create(:player, :average)
  @pitcher = FactoryGirl.create(:player, :average)
  @batter.set_initial_stats
  @pitcher.set_initial_stats

  num_at_bats = 500

  test_name = ""  # This is the name that this test will be represented by and accessed with in the database

  puts "\nsimulating #{num_at_bats} at-bats with the following conditions:"
  attributes_hash.each do |key, value|
    @batter[key.to_sym] = value
    puts "#{key}: #{value}"
    test_name << key << "_#{value}"
  end

  puts ''

  num_singles = 0
  num_doubles = 0
  num_triples = 0
  num_home_runs = 0
  num_walks = 0
  num_strikeouts = 0
  num_outs = 0

  for i in 0..num_at_bats do
    @bases = Bases.new(@game)
    @atBat = AtBat.new(@pitcher, @batter, @game, @bases)
    @play = Play.new(@atBat, @game)
    if HitResult.is_a_home_run(@play.hit_result)
      num_home_runs += 1
    elsif HitResult.is_a_triple(@play.hit_result)
      num_triples += 1
    elsif HitResult.is_a_double(@play.hit_result)
      num_doubles += 1
    elsif HitResult.is_a_single(@play.hit_result)
      num_singles += 1
    elsif @atBat.result == AtBatResult::STRIKEOUT
      num_strikeouts += 1
      num_outs += 1
    elsif @atBat.result == AtBatResult::WALK
      num_walks += 1
    elsif @play.result = PlayResult::OUT
      num_outs += 1
    end
  end
  @avg = (num_singles + num_doubles + num_triples + num_home_runs).to_f/(num_at_bats - num_walks).to_f
  @obp = (num_singles + num_doubles + num_triples + num_home_runs + num_walks).to_f/num_at_bats.to_f
  @slg = (num_singles + 2*num_doubles + 3*num_triples + 4*num_home_runs).to_f/(num_at_bats - num_walks).to_f

  puts "AVG: #{sprintf('%.3f', @avg)}"
  puts "OBP: #{sprintf('%.3f', @obp)}"
  puts "SLG: #{sprintf('%.3f', @slg)}"
  puts "OPS: #{sprintf('%.3f', @obp + @slg)}"
  puts "Doubles: #{num_doubles}, per 600 AB: #{num_doubles.to_f*600/num_at_bats.to_f}"
  puts "Triples: #{num_triples}, per 600 AB: #{num_triples.to_f*600/num_at_bats.to_f}"
  puts "Home runs: #{num_home_runs}, per 600 AB: #{num_home_runs.to_f*600/num_at_bats.to_f}"
  puts "Walks: #{num_walks}, per 600 AB: #{num_walks.to_f*600/num_at_bats.to_f}"
  puts "Strikeouts: #{num_strikeouts}, per 600 AB: #{num_strikeouts.to_f*600/num_at_bats.to_f}\n"

  Test.find_or_initialize_by(:name => test_name).update_attributes!(
    :name => test_name,
    :singles => num_singles,
    :doubles => num_doubles,
    :triples => num_triples,
    :homers => num_home_runs,
    :walks => num_walks,
    :strikeouts => num_strikeouts,
    :atbats => num_at_bats
  )

end

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

task :run_attribute_tests => :environment do
  @team_one = FactoryGirl.create(:team_with_players)
  @team_two = FactoryGirl.create(:team_with_players)
  @game = Game.new(game_params(@team_one, @team_two))
  @game.prepare

  # Single attribute tests
  test_attribute({"power" => 100}, @game)
  test_attribute({"power" => 50}, @game)
  test_attribute({"power" => 0}, @game)
  test_attribute({"contact" => 100}, @game)
  test_attribute({"contact" => 0}, @game)
  test_attribute({"plate_vision" => 100}, @game)
  test_attribute({"plate_vision" => 0}, @game)
  test_attribute({"patience" => 100}, @game)
  test_attribute({"patience" => 0}, @game)
  test_attribute({"batting_average" => 100}, @game)
  test_attribute({"batting_average" => 0}, @game)
  test_attribute({"uppercut_amount" => 100}, @game)
  test_attribute({"uppercut_amount" => 0}, @game)
end

task :simulate_games => :environment do

  puts "Starting simulate_games task"

  if Season.first.simulating <= 10 # Simulate games
    puts "Simulating games..."

    # hash to determine if a team has already played a game (to avoid duplicate games)
    @already_played_hash = Hash.new 0

    # In the future, this will be Season.current (Once multiple seasons are supported)
    @game_number = Season.first.next_game
    puts "game number: #{@game_number}"
    unless @game_number >= 161 then

      Team.find_each do |team|
        unless @already_played_hash[team.id] == 1 then

          current_game_params = {:home_team_id => 1, :away_team_id => 2,
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
            :away_intentional_walks_allowed => "", :player_of_the_game => "", :pbp => "", :play_by_play => ""}

          @game = Game.new(current_game_params)
          schedule = team.schedule.split(", ").map {|s| s.to_i} # array of opponent ids
          @game.away_team_id = schedule[@game_number] # Assume opponent is away team (this will be changed later)
          @game.home_team_id = team.id
          # Add both teams to list of already played teams
          @already_played_hash[schedule[@game_number]] = 1
          @already_played_hash[team.id] = 1
          @game.prepare(Team.find(home_team_id), Team.find(away_team_id), @game_number, 0)
          @game.play
        end
      end # end simulating games

      # increment game number in season
      Season.first.update_attributes(next_game: Season.first.next_game + 1)

    end
    Season.first.update_attribute(:simulating, 1)
  elsif Season.first.simulating == 1
    Season.first.update_attribute(:simulating, 2)
  elsif Season.first.simulating == 2 # Do nothing
    Season.first.update_attribute(:simulating, 0)
  end


end
puts "done."
