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

task :test_rng => :environment do
  include Reusable
  # File.open("data.txt", "w") do |file|
  #   means = [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95]
  #   stdevs = [2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40]
  #   include Reusable
  #   avgBiasSkew = [0.0, 0.0]
  #   min = 0
  #   max = 100
  #   stdev = 10
  #   iterations = 10
  #
  #   means.each do |mean|
  #     stdevs.each do |stdev|
  #       iterations.times do
  #         biasSkew = getBiasAndSkewOfDistribution(0, 100, mean, stdev)
  #         avgBiasSkew[0] += biasSkew[0]
  #         avgBiasSkew[1] += biasSkew[1]
  #       end
  #
  #       avgBiasSkew[0] /= iterations.to_f
  #       avgBiasSkew[1] /= iterations.to_f
  #       file.write("random_numbers[\"#{mean}_#{stdev}\"] = [#{avgBiasSkew[0]}, #{avgBiasSkew[1]}]\n")
  #       puts "Min = #{min}, max = #{max}, mean = #{mean}, stdev = #{stdev} ----> Bias = #{avgBiasSkew[0]}, skew = #{avgBiasSkew[1]}"
  #     end
  #   end
  # end
  total = 0
  desired_mean = 60
  desired_stdev = 16
  num_iterations = 100
  values = []
  num_iterations.times do
    value = getRandomValueFromDistribution(desired_mean, desired_stdev)
    total += value
    values.push(value)
    puts "random value: #{getRandomValueFromDistribution(desired_mean, desired_stdev)}"
  end
  mean = total.to_f/num_iterations.to_f
  stdev = 0.0
  values.each do |value|
    stdev += ((value - mean) ** 2)
  end
  stdev /= num_iterations.to_f
  stdev = stdev ** 0.5
  puts "total numbers generated: #{num_iterations}"
  puts "desired mean: #{desired_mean}, mean = #{mean}"
  puts "desired stdev: #{desired_stdev}, stdev = #{stdev}"
end




# ---------------------------------    START SIMULATE GAMES TASK    ---------------------------------------
task :simulate_games => :environment do
  num_seasons = 20
  num_seasons.times do

    include Reusable
    @year = Season.last.year + 1
    @season = Season.create!(current_date: Date.parse("1st April #{@year}"), year: @year) # Create new season
    @current_date = @season.current_date

    # RESET TEAM STATS
    Team.where("id > 2").each_with_index do |team, index|
      puts "Resetting stats for team #{index} of 30..."
      team.reset_season_stats
    end

    # RESET PLAYER STATS, HANDLE PLAYER RETIREMENT
    Player.where("retired != 1").each_with_index do |player, index| # Reset player stats
      puts "Resetting stats for player #{index}..."
      player.reset_season_stats
      player.retires?(@season.current_date)
    end

    # DRAFT
    puts "Generating draft list..."
    40.times do
      pitcher = completely_random_pitcher(1, true)
    end # 40 pitchers in each draft
    60.times do
      player = completely_random_player(1, true)
    end # 60 position players in each draft
    puts "Simulating draft..."
    if @year == 2001 # Draft order determined by salary (low to high) for first season
      @draft_teams = Team.where("id > 2").sort_by { |team| team.get_total_payroll }
    else # Draft order determined by previous year's record (low to high) for all other seasons
      @draft_teams = Team.where("id > 2").sort_by { |team| team.season_team_stats.last.wins }
    end
    @draft_list = Player.where("team_id = 1").sort_by { |player| -player.salary } # By default, teams draft highest salaried player
    draft_order = "" # String that will eventually be filled with drafted player ids, separated by underscores
    3.times do |round|
      @draft_teams.each_with_index do |team, index|
        drafted_player = @draft_list.shift
        puts "With pick #{index + 1} in round #{round + 1} of the #{@year} draft, the #{team.full_name} select #{drafted_player.full_name}."
        drafted_player.update_columns(:team_id => team.id, :level => "Minors", :draft_year => @year, :draft_round => round + 1, :draft_position => index + 1)
        draft_order += "#{drafted_player.id}_"
        Transaction.create!(team_id: team.id, transaction_type: "Draft", drafted_player_id: drafted_player.id, transaction_date: @season.current_date) # Save draft transaction
      end
    end
    Draft.create!(year: @year, order: draft_order.chop) # Save completed draft to database (chop removes trailing underscore)
    @draft_list.each do |undrafted_player| # All remaining undrafted players become free agents
      puts "#{undrafted_player.full_name} was undrafted and is now a free agent."
      undrafted_player.update_columns(:team_id => 2)
    end

    # FREE AGENT SIGNING
    team_hash = Hash.new 0 # Key = team id, Value = true/false depending on whether the team can still sign another free agent
    used_players_hash = Hash.new 0 # Key = team id, value = array of ids of players that have already been added or dropped (to avoid duplicate add/drops)
    teams = Team.where("id > 2").to_a
    teams.each do |team|
      team_hash[team.id] = true # fill hash with true for each team
      used_players_hash[team.id] = [] # fill hash with empty array
    end
    puts "Free agent signing period has begun..."
    while team_hash.has_value?(true) # As long as at least one team has not yet signed all possible free agents
      random_team = teams.sample # choose a random team
      pitchers = random_team.get_pitchers_on_active_roster.sort_by { |player| player.salary }
      position_players = random_team.get_position_players_on_active_roster.sort_by { |player| player.salary }
      available_free_agent_pitchers = Player.where("team_id = 2 AND position = 'P' AND retired != 1").sort_by { |free_agent_pitcher| -free_agent_pitcher.salary } # get available free agent pitchers, sort descending by salary
      available_free_agent_position_players = Player.where("team_id = 2 AND position != 'P' AND retired != 1").sort_by { |free_agent_position_player| -free_agent_position_player.salary } # get available free agent position players, sort descending by salary
      # Check if the highest salary free agent has a higher salary than the lowest salary player on the team (first pitchers, then position players)
      if available_free_agent_pitchers.first.salary > pitchers.first.salary && !used_players_hash[random_team.id].include?(available_free_agent_pitchers.first.id) && !used_players_hash[random_team.id].include?(pitchers.first.id)
        used_players_hash[random_team.id].push(available_free_agent_pitchers.first.id)
        used_players_hash[random_team.id].push(pitchers.first.id)
        random_team.replace_pitcher(available_free_agent_pitchers.first, pitchers.first)
        puts "The #{random_team.full_name} sign #{available_free_agent_pitchers.first.position} #{available_free_agent_pitchers.first.full_name} (#{available_free_agent_pitchers.first.salary}), drop #{pitchers.first.position} #{pitchers.first.full_name} (#{pitchers.first.salary})."
        Transaction.create!(team_id: random_team.id, transaction_type: "Signing", signed_player_id: available_free_agent_pitchers.first.id, dropped_player_id: pitchers.first.id, transaction_date: @season.current_date)
      elsif available_free_agent_position_players.first.salary > position_players.first.salary && !used_players_hash[random_team.id].include?(available_free_agent_position_players.first.id) && !used_players_hash[random_team.id].include?(position_players.first.id)
        used_players_hash[random_team.id].push(available_free_agent_position_players.first.id)
        used_players_hash[random_team.id].push(position_players.first.id)
        random_team.replace_position_player(available_free_agent_position_players.first, position_players.first)
        puts "The #{random_team.full_name} sign #{available_free_agent_position_players.first.position} #{available_free_agent_position_players.first.full_name} (#{available_free_agent_position_players.first.salary}), drop #{position_players.first.position} #{position_players.first.full_name} (#{position_players.first.salary})."
        Transaction.create!(team_id: random_team.id, transaction_type: "Signing", signed_player_id: available_free_agent_position_players.first.id, dropped_player_id: position_players.first.id, transaction_date: @season.current_date)
      else
        puts "The #{random_team.full_name} cannot sign any free agents at this time."
        team_hash[random_team.id] = false
        teams.each_with_index do |team, index| # Remove team from teams array
          if team.id == random_team.id
            teams.delete_at(index)
          end
        end
      end
    end
    puts "Free agent signing period has ended..."

    # PLAYER PROMOTION, LINEUP SUBSTITUTIONS
    Team.where("id > 2").each do |team|
      team.optimize_roster(@season.current_date)
    end

    # CREATE SEASON SCHEDULE
    puts "creating schedules for season #{@season.id}..."
    @series = {"TWO_GAME" => 2, "THREE_GAME" => 42, "FOUR_GAME" => 8}
    52.times do |index|
      puts "generating series #{index} of 52..."
      remaining_team_ids = [] # Array of remaining team ids (so that there are no duplicate games)
      Team.where("id > 2").each do |team|
        remaining_team_ids.push(team.id)
      end
      num_games = 0 # Determine number of games in the series
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
      count = 0
      while remaining_team_ids.length > 0
        count += 1
        create_series(index, num_games, remaining_team_ids, @current_date)
      end
      @current_date += num_games
      if index % 3 == 0
        @current_date += 1
      end # off day every 3 series
    end # End creating season schedule

    # SIMULATE SEASON
    puts "Starting sim at #{Time.now}"
    190.times do |index|
      Game.where("sim_date = ? && season_id = ?", @season.current_date, @season.id).each_with_index do |game, index| # Find all games on this date
        puts "#{@season.current_date.strftime("%B %e, %Y")}: simulating game #{index + 1}..."
        game.prepare(Team.find(game.home_team_id), Team.find(game.away_team_id), @season.id)
        game.play
      end
      @season.update_columns(:current_date => @season.current_date.next_day) # Increment season date
    end # End simulating season

    # SIMULATE PLAYOFFS (tiebreakers: 1. wins, 2. runs scored, 3. runs allowed, 4. coin flip)
    puts "Playoffs beginning..."
    nl_division_winners = []
    al_division_winners = []
    nl_division_winners.push(Team.where("league = 'NL' AND division = 'East'").to_a.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] }.first) # NL East winner
    nl_division_winners.push(Team.where("league = 'NL' AND division = 'Central'").to_a.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] }.first) # NL Central winner
    nl_division_winners.push(Team.where("league = 'NL' AND division = 'West'").to_a.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] }.first) # NL West winner
    al_division_winners.push(Team.where("league = 'AL' AND division = 'East'").to_a.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] }.first) # AL East winner
    al_division_winners.push(Team.where("league = 'AL' AND division = 'Central'").to_a.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] }.first) # AL Central winner
    al_division_winners.push(Team.where("league = 'AL' AND division = 'West'").to_a.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] }.first) # AL West winner
    nl_division_winners.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] } # Sort NL division winners
    al_division_winners.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] } # Sort AL division winners
    nl_wild_card_teams = [] # Two NL wild card teams
    al_wild_card_teams = [] # Two AL wild card teams
    Team.where("league = 'NL'").to_a.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] }.each do |team|
      if !nl_division_winners.include? team # Wild card teams can't be a division winner
        nl_wild_card_teams.push(team)
      end
      if nl_wild_card_teams.length == 2 # Only 2 wild card teams
        break
      end
    end
    Team.where("league = 'AL'").to_a.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] }.each do |team|
      if !al_division_winners.include? team # Wild card teams can't be a division winner
        al_wild_card_teams.push(team)
      end
      if al_wild_card_teams.length == 2 # Only 2 wild card teams
        break
      end
    end
    nl_wild_card_teams.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] } # Determine home field for wild card game
    al_wild_card_teams.sort_by { |team| [team.wins, -team.runs_scored, team.runs_allowed, rand()] } # Determine home field for wild card game
    puts "Wild card play-in games beginning..."
    # NL WILD CARD PLAY-IN GAME
    puts "Simulating NL Wild Card play-in game between the #{nl_wild_card_teams[0].full_name} and the #{nl_wild_card_teams[1].full_name}..."
    game = Game.create!(:home_team_id => nl_wild_card_teams[0].id, :away_team_id => nl_wild_card_teams[1].id,
      :sim_date => @season.current_date, :season_id => @season.id, :game_type => "NL_WC")
    game.prepare(nl_wild_card_teams[0], nl_wild_card_teams[1], @season.id)
    game.play
    nl_wild_card_winner = Team.find(game.winning_team)
    puts "The #{nl_wild_card_winner.full_name} win the NL Wild Card play-in game."

    # AL WILD CARD PLAY-IN GAME
    puts "Simulating NL Wild Card play-in game between the #{al_wild_card_teams[0].full_name} and the #{al_wild_card_teams[1].full_name}..."
    game = Game.create!(:home_team_id => al_wild_card_teams[0].id, :away_team_id => al_wild_card_teams[1].id,
      :sim_date => @season.current_date, :season_id => @season.id, :game_type => "AL_WC")
    game.prepare(al_wild_card_teams[0], al_wild_card_teams[1], @season.id)
    game.play
    al_wild_card_winner = Team.find(game.winning_team)
    puts "The #{al_wild_card_winner.full_name} win the AL Wild Card play-in game."
    @season.update_columns(:current_date => @season.current_date.next_day)

    # DIVISION SERIES (5 game series, 2-2-1)
    puts "Division series beginning..."
    puts "NL Matchups: #{nl_division_winners[0].name} vs. #{nl_wild_card_winner.name}, #{nl_division_winners[1].name} vs. #{nl_division_winners[2].name}."
    puts "AL Matchups: #{al_division_winners[0].name} vs. #{al_wild_card_winner.name}, #{al_division_winners[1].name} vs. #{al_division_winners[2].name}."
    home_field = [true, true, false, false, true]
    nl_1_seed_wins = 0
    nl_2_seed_wins = 0
    nl_3_seed_wins = 0
    nl_4_seed_wins = 0
    al_1_seed_wins = 0
    al_2_seed_wins = 0
    al_3_seed_wins = 0
    al_4_seed_wins = 0
    nl_division_series_winners = []
    al_division_series_winners = []
    5.times do |index|
      # NL Division Series, #1 vs #4 (wild card winner)
      if nl_1_seed_wins < 3 && nl_4_seed_wins < 3
        if home_field[index]
          game = Game.create!(:home_team_id => nl_division_winners[0].id, :away_team_id => nl_wild_card_winner.id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "NLDS_1_v_4")
          game.prepare(nl_division_winners[0], nl_wild_card_winner, @season.id)
          game.play
          if game.winning_team == nl_division_winners[0].id
            nl_1_seed_wins += 1
          else
            nl_4_seed_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        else
          game = Game.create!(:home_team_id => nl_wild_card_winner.id, :away_team_id => nl_division_winners[0].id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "NLDS_1_v_4")
          game.prepare(nl_wild_card_winner, nl_division_winners[0], @season.id)
          game.play
          if game.winning_team == nl_division_winners[0].id
            nl_1_seed_wins += 1
          else
            nl_4_seed_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        end
        if nl_1_seed_wins == 3
          nl_division_series_winners.push(nl_division_winners[0])
          puts "The #{nl_division_winners[0].full_name} win the division series against the #{nl_wild_card_winner.full_name}"
          nl_division_winners[0].update_columns(:division_series_wins => 1)
        elsif nl_4_seed_wins == 3
          nl_division_series_winners.push(nl_wild_card_winner)
          puts "The #{nl_wild_card_winner.full_name} win the division series against the #{nl_division_winners[0].full_name}"
          nl_wild_card_winner.update_columns(:division_series_wins => 1)
        end
      end
      # NL Division Series, #2 vs #3
      if nl_2_seed_wins < 3 && nl_3_seed_wins < 3
        if home_field[index]
          game = Game.create!(:home_team_id => nl_division_winners[1].id, :away_team_id => nl_division_winners[2].id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "NLDS_2_v_3")
          game.prepare(nl_division_winners[1], nl_division_winners[2], @season.id)
          game.play
          if game.winning_team == nl_division_winners[1].id
            nl_2_seed_wins += 1
          else
            nl_3_seed_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        else
          game = Game.create!(:home_team_id => nl_division_winners[2].id, :away_team_id => nl_division_winners[1].id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "NLDS_2_v_3")
          game.prepare(nl_division_winners[2], nl_division_winners[1], @season.id)
          game.play
          if game.winning_team == nl_division_winners[1].id
            nl_2_seed_wins += 1
          else
            nl_3_seed_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        end
        if nl_2_seed_wins == 3
          nl_division_series_winners.push(nl_division_winners[1])
          puts "The #{nl_division_winners[1].full_name} win the division series against the #{nl_division_winners[2].full_name}"
          nl_division_winners[1].update_columns(:division_series_wins => 1)
        elsif nl_3_seed_wins == 3
          nl_division_series_winners.push(nl_division_winners[2])
          puts "The #{nl_division_winners[2].full_name} win the division series against the #{nl_division_winners[1].full_name}"
          nl_division_winners[2].update_columns(:division_series_wins => 1)
        end
      end
      # AL Division Series, #1 vs #4 (wild card winner)
      if al_1_seed_wins < 3 && al_4_seed_wins < 3
        if home_field[index]
          game = Game.create!(:home_team_id => al_division_winners[0].id, :away_team_id => al_wild_card_winner.id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "ALDS_1_v_4")
          game.prepare(al_division_winners[0], al_wild_card_winner, @season.id)
          game.play
          if game.winning_team == al_division_winners[0].id
            al_1_seed_wins += 1
          else
            al_4_seed_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        else
          game = Game.create!(:home_team_id => al_wild_card_winner.id, :away_team_id => al_division_winners[0].id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "ALDS_1_v_4")
          game.prepare(al_wild_card_winner, al_division_winners[0], @season.id)
          game.play
          if game.winning_team == al_division_winners[0].id
            al_1_seed_wins += 1
          else
            al_4_seed_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        end
        if al_1_seed_wins == 3
          al_division_series_winners.push(al_division_winners[0])
          puts "The #{al_division_winners[0].full_name} win the division series against the #{al_wild_card_winner.full_name}"
          al_division_winners[0].update_columns(:division_series_wins => 1)
        elsif al_4_seed_wins == 3
          al_division_series_winners.push(al_wild_card_winner)
          puts "The #{al_wild_card_winner.full_name} win the division series against the #{al_division_winners[0].full_name}"
          al_wild_card_winner.update_columns(:division_series_wins => 1)
        end
      end
      # AL Division Series, #2 vs #3
      if al_2_seed_wins < 3 && al_3_seed_wins < 3
        if home_field[index]
          game = Game.create!(:home_team_id => al_division_winners[1].id, :away_team_id => al_division_winners[2].id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "ALDS_2_v_3")
          game.prepare(al_division_winners[1], al_division_winners[2], @season.id)
          game.play
          if game.winning_team == al_division_winners[1].id
            al_2_seed_wins += 1
          else
            al_3_seed_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        else
          game = Game.create!(:home_team_id => al_division_winners[2].id, :away_team_id => al_division_winners[1].id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "ALDS_2_v_3")
          game.prepare(al_division_winners[2], al_division_winners[1], @season.id)
          game.play
          if game.winning_team == al_division_winners[1].id
            al_2_seed_wins += 1
          else
            al_3_seed_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        end
        if al_2_seed_wins == 3
          al_division_series_winners.push(al_division_winners[1])
          puts "The #{al_division_winners[1].full_name} win the division series against the #{al_division_winners[2].full_name}"
          al_division_winners[1].update_columns(:division_series_wins => 1)
        elsif al_3_seed_wins == 3
          al_division_series_winners.push(al_division_winners[2])
          puts "The #{al_division_winners[2].full_name} win the division series against the #{al_division_winners[1].full_name}"
          al_division_winners[2].update_columns(:division_series_wins => 1)
        end
      end
      @season.update_columns(:current_date => @season.current_date.next_day)
    end

    nl_division_series_winners.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] }
    al_division_series_winners.sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] }

    # CHAMPIONSHIP SERIES (7 game series, 2-2-1-1-1)
    puts "Championship series beginning..."
    puts "NL Matchup: #{nl_division_series_winners[0].name} vs. #{nl_division_series_winners[1].name}."
    puts "AL Matchup: #{al_division_series_winners[0].name} vs. #{al_division_series_winners[1].name}."
    home_field = [true, true, false, false, true, false, true]
    nl_1_seed_wins = 0
    nl_2_seed_wins = 0
    al_1_seed_wins = 0
    al_2_seed_wins = 0
    nl_championship_series_winner = nil
    al_championship_series_winner = nil

    7.times do |index|
      # NL Championship Series
      if nl_1_seed_wins < 4 && nl_2_seed_wins < 4
        if home_field[index]
          game = Game.create!(:home_team_id => nl_division_series_winners[0].id, :away_team_id => nl_division_series_winners[1].id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "NLCS")
          game.prepare(nl_division_series_winners[0], nl_division_series_winners[1], @season.id)
          game.play
          if game.winning_team == nl_division_series_winners[0].id
            nl_1_seed_wins += 1
          else
            nl_2_seed_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        else
          game = Game.create!(:home_team_id => nl_division_series_winners[1].id, :away_team_id => nl_division_series_winners[0].id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "NLCS")
          game.prepare(nl_division_series_winners[1], nl_division_series_winners[0], @season.id)
          game.play
          if game.winning_team == nl_division_series_winners[0].id
            nl_1_seed_wins += 1
          else
            nl_2_seed_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        end
        if nl_1_seed_wins == 4
          nl_championship_series_winner = nl_division_series_winners[0]
          puts "The #{nl_division_series_winners[0].full_name} win the championship series against the #{nl_division_series_winners[1].full_name}"
          nl_division_series_winners[0].update_columns(:championship_series_wins => 1)
        elsif nl_2_seed_wins == 4
          nl_championship_series_winner = nl_division_series_winners[1]
          puts "The #{nl_division_series_winners[1].full_name} win the championship series against the #{nl_division_series_winners[0].full_name}"
          nl_division_series_winners[1].update_columns(:championship_series_wins => 1)
        end
      end
      # AL Championship Series
      if al_1_seed_wins < 4 && al_2_seed_wins < 4
        if home_field[index]
          game = Game.create!(:home_team_id => al_division_series_winners[0].id, :away_team_id => al_division_series_winners[1].id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "ALCS")
          game.prepare(al_division_series_winners[0], al_division_series_winners[1], @season.id)
          game.play
          if game.winning_team == al_division_series_winners[0].id
            al_1_seed_wins += 1
          else
            al_2_seed_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        else
          game = Game.create!(:home_team_id => al_division_series_winners[1].id, :away_team_id => al_division_series_winners[0].id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "ALCS")
          game.prepare(al_division_series_winners[1], al_division_series_winners[0], @season.id)
          game.play
          if game.winning_team == al_division_series_winners[0].id
            al_1_seed_wins += 1
          else
            al_2_seed_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        end
        if al_1_seed_wins == 4
          al_championship_series_winner = al_division_series_winners[0]
          puts "The #{al_division_series_winners[0].full_name} win the championship series against the #{al_division_series_winners[1].full_name}"
          al_division_series_winners[0].update_columns(:championship_series_wins => 1)
        elsif al_2_seed_wins == 4
          al_championship_series_winner = al_division_series_winners[1]
          puts "The #{al_division_series_winners[1].full_name} win the championship series against the #{al_division_series_winners[0].full_name}"
          al_division_series_winners[1].update_columns(:championship_series_wins => 1)
        end
      end
      @season.update_columns(:current_date => @season.current_date.next_day)
    end

    # WORLD SERIES
    world_series_teams = [nl_championship_series_winner, al_championship_series_winner].sort_by { |team| [-team.wins, -team.runs_scored, team.runs_allowed, rand()] }
    puts "World series beginning (#{world_series_teams[0].name} vs. #{world_series_teams[1].name})..."
    home_field = [true, true, false, false, true, false, true]
    ws_team_1_wins = 0
    ws_team_2_wins = 0
    world_series_winner = nil
    7.times do |index|
      if ws_team_1_wins < 4 && ws_team_2_wins < 4
        if home_field[index]
          game = Game.create!(:home_team_id => world_series_teams[0].id, :away_team_id => world_series_teams[1].id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "WS")
          game.prepare(world_series_teams[0], world_series_teams[1], @season.id)
          game.play
          if game.winning_team == world_series_teams[0].id
            ws_team_1_wins += 1
          else
            ws_team_2_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        else
          game = Game.create!(:home_team_id => world_series_teams[1].id, :away_team_id => world_series_teams[0].id,
            :sim_date => @season.current_date, :season_id => @season.id, :game_type => "WS")
          game.prepare(world_series_teams[1], world_series_teams[0], @season.id)
          game.play
          if game.winning_team == world_series_teams[0].id
            ws_team_1_wins += 1
          else
            ws_team_2_wins += 1
          end
          puts "The #{Team.find(game.winning_team).full_name} beat the #{Team.find(game.losing_team).full_name} in Game #{index + 1}."
        end
        if ws_team_1_wins == 4
          world_series_winner = world_series_teams[0]
          puts "The #{world_series_teams[0].full_name} win the world series against the #{world_series_teams[1].full_name}"
          world_series_teams[0].update_columns(:world_series_wins => 1)
        elsif ws_team_2_wins == 4
          world_series_winner = world_series_teams[1]
          puts "The #{world_series_teams[1].full_name} win the world series against the #{world_series_teams[0].full_name}"
          world_series_teams[1].update_columns(:world_series_wins => 1)
        end
      end
      @season.update_columns(:current_date => @season.current_date.next_day)
    end

    # SAVE TEAM STATS
    Team.where("id > 2").each do |team|
      puts "Saving stats for the #{team.full_name}"
      team.save_season_stats(@season.id)
    end

    # SAVE PLAYER STATS AND ATTRIBUTES, UPDATE PLAYER ATTRIBUTES, HANDLE RETIREMENT
    Player.where("retired != 1").each_with_index do |player, index|
      puts "Saving stats and attributes for player #{index} (#{player.full_name})..."
      player.save_season_attributes(@season.id)
      player.save_season_batting_stats(@season.id)
      player.save_season_fielding_stats(@season.id)
      player.save_season_pitching_stats(@season.id)
      puts "Updating attributes for player #{index} (#{player.full_name})..."
      player.update_current_attributes
      player.retires?(@season.current_date)
    end

  end # End season
end # End simulate_games
# ---------------------------------    END SIMULATE GAMES TASK    ---------------------------------------









def create_series(series_index, num_games, remaining_team_ids, current_date)

  team_id = remaining_team_ids.sample
  remaining_team_ids.delete(team_id)
  team = Team.find(team_id)
  # CREATE NEW SERIES
  # Home or away?
  home = [true, false].sample
  # Find opponent
  opponent_id = remaining_team_ids.sample
  remaining_team_ids.delete(opponent_id)

  home_id = home ? team_id : opponent_id
  away_id = home ? opponent_id : team_id

  # Now, create games
  num_games.times do |game_num|

    game_params = {:home_team_id => home_id, :away_team_id => away_id,
      :sim_date => current_date + game_num, :season_id => @season.id}

    game = Game.new(game_params)

    # save the game
    game.save
  end


end
