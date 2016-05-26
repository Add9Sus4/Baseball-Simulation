class Game < ActiveRecord::Base
  validate :teams_must_be_different
  attr_accessor :pbp, :bad, :good, :home_team, :away_team, :pitch_locations, :heat_maps, :inning_status, :inning_number, :away_team_lineup_position, :home_team_lineup_position, :away_team_score, :home_team_score, :home_team_inning_scores, :away_team_inning_scores, :over

  def teams_must_be_different
    errors.add(:base, "Teams cannot be the same") if home_team_id == away_team_id
  end

  # Plays a game
  def play
    prepare
    @over = false
    @inning_number = 1
    @inning_status = InningStatus::TOP
    @home_team_lineup_position = 0
    @away_team_lineup_position = 0
    @home_team_score = 0
    @away_team_score = 0
    @home_team_inning_scores = ""
    @away_team_inning_scores = ""
    @pbp = ""
    @good = "#267373"
    @bad = "#854747"

    # Simulate game
    while !@over do
      # Top of inning
      unless @inning_number == 1 && @inning_status == InningStatus::TOP
        @pbp += "\n____________________________________________________________________________\n"
      end
      @pbp += "\n<h4><strong>Top of inning #{@inning_number} (#{@away_team.full_name} batting):</strong></h4>\n"
      @inning_status = InningStatus::TOP
      inning = Inning.new(self)
      # Bottom of inning
      if @inning_number == 9 && @home_team_score > @away_team_score
        @over = true
      end
      @pbp += "\n____________________________________________________________________________\n"
      @pbp += "\n<h4><strong>Bottom of inning #{@inning_number} (#{@home_team.full_name} batting):</strong></h4>\n"
      @inning_status = InningStatus::BOTTOM
      inning = Inning.new(self)
      if @inning_number > 8 && @home_team_score != @away_team_score
        @over = true
      end
      @inning_number = @inning_number + 1
    end

    collect_stats
  end

  def collect_stats

    # home batting stats
    home_at_bats_string = ""
    home_runs_scored_string = ""
    home_hits_string = ""
    home_doubles_string = ""
    home_triples_string = ""
    home_home_runs_string = ""
    home_RBI_string = ""
    home_walks_string = ""
    home_strikeouts_string = ""
    home_stolen_bases_string = ""
    home_caught_stealing_string = ""
    home_errors_string = ""
    home_assists_string = ""
    home_putouts_string = ""
    home_chances_string = ""

    # away batting stats
    away_at_bats_string = ""
    away_runs_scored_string = ""
    away_hits_string = ""
    away_doubles_string = ""
    away_triples_string = ""
    away_home_runs_string = ""
    away_RBI_string = ""
    away_walks_string = ""
    away_strikeouts_string = ""
    away_stolen_bases_string = ""
    away_caught_stealing_string = ""
    away_errors_string = ""
    away_assists_string = ""
    away_putouts_string = ""
    away_chances_string = ""

    # home pitching stats
    home_outs_recorded_string = ""
    home_hits_allowed_string = ""
    home_runs_allowed_string = ""
    home_earned_runs_allowed_string = ""
    home_walks_allowed_string = ""
    home_strikeouts_recorded_string = ""
    home_home_runs_allowed_string = ""
    home_total_pitches_string = ""
    home_strikes_thrown_string = ""
    home_balls_thrown_string = ""
    home_intentional_walks_allowed_string = ""

    # away pitching stats
    away_outs_recorded_string = ""
    away_hits_allowed_string = ""
    away_runs_allowed_string = ""
    away_earned_runs_allowed_string = ""
    away_walks_allowed_string = ""
    away_strikeouts_recorded_string = ""
    away_home_runs_allowed_string = ""
    away_total_pitches_string = ""
    away_strikes_thrown_string = ""
    away_balls_thrown_string = ""
    away_intentional_walks_allowed_string = ""

    for i in 0..8 do
      # home batting stats
      home_at_bats_string = home_at_bats_string + "#{@home_team.find_player_by_lineup_index(i).at_bats}"
      home_runs_scored_string = home_runs_scored_string + "#{@home_team.find_player_by_lineup_index(i).runs_scored}"
      home_hits_string = home_hits_string + "#{@home_team.find_player_by_lineup_index(i).hits}"
      home_doubles_string = home_doubles_string + "#{@home_team.find_player_by_lineup_index(i).doubles}"
      home_triples_string = home_triples_string + "#{@home_team.find_player_by_lineup_index(i).triples}"
      home_home_runs_string = home_home_runs_string + "#{@home_team.find_player_by_lineup_index(i).home_runs}"
      home_RBI_string = home_RBI_string + "#{@home_team.find_player_by_lineup_index(i).rbi}"
      home_walks_string = home_walks_string + "#{@home_team.find_player_by_lineup_index(i).walks}"
      home_strikeouts_string = home_strikeouts_string + "#{@home_team.find_player_by_lineup_index(i).strikeouts}"
      home_stolen_bases_string = home_stolen_bases_string + "#{@home_team.find_player_by_lineup_index(i).stolen_bases}"
      home_caught_stealing_string = home_caught_stealing_string + "#{@home_team.find_player_by_lineup_index(i).caught_stealing}"
      home_errors_string = home_errors_string + "#{@home_team.find_player_by_lineup_index(i).errors_committed}"
      home_assists_string = home_assists_string + "#{@home_team.find_player_by_lineup_index(i).assists}"
      home_putouts_string = home_putouts_string + "#{@home_team.find_player_by_lineup_index(i).putouts}"
      home_chances_string = home_chances_string + "#{@home_team.find_player_by_lineup_index(i).chances}"

      # away batting stats
      away_at_bats_string = away_at_bats_string + "#{@away_team.find_player_by_lineup_index(i).at_bats}"
      away_runs_scored_string = away_runs_scored_string + "#{@away_team.find_player_by_lineup_index(i).runs_scored}"
      away_hits_string = away_hits_string + "#{@away_team.find_player_by_lineup_index(i).hits}"
      away_doubles_string = away_doubles_string + "#{@away_team.find_player_by_lineup_index(i).doubles}"
      away_triples_string = away_triples_string + "#{@away_team.find_player_by_lineup_index(i).triples}"
      away_home_runs_string = away_home_runs_string + "#{@away_team.find_player_by_lineup_index(i).home_runs}"
      away_RBI_string = away_RBI_string + "#{@away_team.find_player_by_lineup_index(i).rbi}"
      away_walks_string = away_walks_string + "#{@away_team.find_player_by_lineup_index(i).walks}"
      away_strikeouts_string = away_strikeouts_string + "#{@away_team.find_player_by_lineup_index(i).strikeouts}"
      away_stolen_bases_string = away_stolen_bases_string + "#{@away_team.find_player_by_lineup_index(i).stolen_bases}"
      away_caught_stealing_string = away_caught_stealing_string + "#{@away_team.find_player_by_lineup_index(i).caught_stealing}"
      away_errors_string = away_errors_string + "#{@away_team.find_player_by_lineup_index(i).errors_committed}"
      away_assists_string = away_assists_string + "#{@away_team.find_player_by_lineup_index(i).assists}"
      away_putouts_string = away_putouts_string + "#{@away_team.find_player_by_lineup_index(i).putouts}"
      away_chances_string = away_chances_string + "#{@away_team.find_player_by_lineup_index(i).chances}"

      # home pitching stats
      home_outs_recorded_string = home_outs_recorded_string + "#{@home_team.find_player_by_lineup_index(i).outs_recorded}"
      home_hits_allowed_string = home_hits_allowed_string + "#{@home_team.find_player_by_lineup_index(i).hits_allowed}"
      home_runs_allowed_string = home_runs_allowed_string + "#{@home_team.find_player_by_lineup_index(i).runs_allowed}"
      home_earned_runs_allowed_string = home_earned_runs_allowed_string + "#{@home_team.find_player_by_lineup_index(i).earned_runs_allowed}"
      home_walks_allowed_string = home_walks_allowed_string + "#{@home_team.find_player_by_lineup_index(i).walks_allowed}"
      home_strikeouts_recorded_string = home_strikeouts_recorded_string + "#{@home_team.find_player_by_lineup_index(i).strikeouts_recorded}"
      home_home_runs_allowed_string = home_home_runs_allowed_string + "#{@home_team.find_player_by_lineup_index(i).home_runs_allowed}"
      home_total_pitches_string = home_total_pitches_string + "#{@home_team.find_player_by_lineup_index(i).total_pitches}"
      home_strikes_thrown_string = home_strikes_thrown_string + "#{@home_team.find_player_by_lineup_index(i).strikes_thrown}"
      home_balls_thrown_string = home_balls_thrown_string + "#{@home_team.find_player_by_lineup_index(i).balls_thrown}"
      home_intentional_walks_allowed_string = home_intentional_walks_allowed_string + "#{@home_team.find_player_by_lineup_index(i).intentional_walks_allowed}"

      # away pitching stats
      away_outs_recorded_string = away_outs_recorded_string + "#{@away_team.find_player_by_lineup_index(i).outs_recorded}"
      away_hits_allowed_string = away_hits_allowed_string + "#{@away_team.find_player_by_lineup_index(i).hits_allowed}"
      away_runs_allowed_string = away_runs_allowed_string + "#{@away_team.find_player_by_lineup_index(i).runs_allowed}"
      away_earned_runs_allowed_string = away_earned_runs_allowed_string + "#{@away_team.find_player_by_lineup_index(i).earned_runs_allowed}"
      away_walks_allowed_string = away_walks_allowed_string + "#{@away_team.find_player_by_lineup_index(i).walks_allowed}"
      away_strikeouts_recorded_string = away_strikeouts_recorded_string + "#{@away_team.find_player_by_lineup_index(i).strikeouts_recorded}"
      away_home_runs_allowed_string = away_home_runs_allowed_string + "#{@away_team.find_player_by_lineup_index(i).home_runs_allowed}"
      away_total_pitches_string = away_total_pitches_string + "#{@away_team.find_player_by_lineup_index(i).total_pitches}"
      away_strikes_thrown_string = away_strikes_thrown_string + "#{@away_team.find_player_by_lineup_index(i).strikes_thrown}"
      away_balls_thrown_string = away_balls_thrown_string + "#{@away_team.find_player_by_lineup_index(i).balls_thrown}"
      away_intentional_walks_allowed_string = away_intentional_walks_allowed_string + "#{@away_team.find_player_by_lineup_index(i).intentional_walks_allowed}"

      if i < 8
        # home batting stats
        home_at_bats_string = home_at_bats_string + "_"
        home_runs_scored_string = home_runs_scored_string + "_"
        home_hits_string = home_hits_string + "_"
        home_doubles_string = home_doubles_string + "_"
        home_triples_string = home_triples_string + "_"
        home_home_runs_string = home_home_runs_string + "_"
        home_RBI_string = home_RBI_string + "_"
        home_walks_string = home_walks_string + "_"
        home_strikeouts_string = home_strikeouts_string + "_"
        home_stolen_bases_string = home_stolen_bases_string + "_"
        home_caught_stealing_string = home_caught_stealing_string + "_"
        home_errors_string = home_errors_string + "_"
        home_assists_string = home_assists_string + "_"
        home_putouts_string = home_putouts_string + "_"
        home_chances_string = home_chances_string + "_"

        # away batting stats
        away_at_bats_string = away_at_bats_string + "_"
        away_runs_scored_string = away_runs_scored_string + "_"
        away_hits_string = away_hits_string + "_"
        away_doubles_string = away_doubles_string + "_"
        away_triples_string = away_triples_string + "_"
        away_home_runs_string = away_home_runs_string + "_"
        away_RBI_string = away_RBI_string + "_"
        away_walks_string = away_walks_string + "_"
        away_strikeouts_string = away_strikeouts_string + "_"
        away_stolen_bases_string = away_stolen_bases_string + "_"
        away_caught_stealing_string = away_caught_stealing_string + "_"
        away_errors_string = away_errors_string + "_"
        away_assists_string = away_assists_string + "_"
        away_putouts_string = away_putouts_string + "_"
        away_chances_string = away_chances_string + "_"

        # home pitching stats
        home_outs_recorded_string = home_outs_recorded_string + "_"
        home_hits_allowed_string = home_hits_allowed_string + "_"
        home_runs_allowed_string = home_runs_allowed_string + "_"
        home_earned_runs_allowed_string = home_earned_runs_allowed_string + "_"
        home_walks_allowed_string = home_walks_allowed_string + "_"
        home_strikeouts_recorded_string = home_strikeouts_recorded_string + "_"
        home_home_runs_allowed_string = home_home_runs_allowed_string + "_"
        home_total_pitches_string = home_total_pitches_string + "_"
        home_strikes_thrown_string = home_strikes_thrown_string + "_"
        home_balls_thrown_string = home_balls_thrown_string + "_"
        home_intentional_walks_allowed_string = home_intentional_walks_allowed_string + "_"

        # away pitching stats
        away_outs_recorded_string = away_outs_recorded_string + "_"
        away_hits_allowed_string = away_hits_allowed_string + "_"
        away_runs_allowed_string = away_runs_allowed_string + "_"
        away_earned_runs_allowed_string = away_earned_runs_allowed_string + "_"
        away_walks_allowed_string = away_walks_allowed_string + "_"
        away_strikeouts_recorded_string = away_strikeouts_recorded_string + "_"
        away_home_runs_allowed_string = away_home_runs_allowed_string + "_"
        away_total_pitches_string = away_total_pitches_string + "_"
        away_strikes_thrown_string = away_strikes_thrown_string + "_"
        away_balls_thrown_string = away_balls_thrown_string + "_"
        away_intentional_walks_allowed_string = away_intentional_walks_allowed_string + "_"
      end
    end

    # runs scored in each inning
    self.update_attributes(away_inning_scores: @away_team_inning_scores.chop)
    self.update_attributes(home_inning_scores: @home_team_inning_scores.chop)

    # home batting stats
    self.update_attributes(home_atbats: home_at_bats_string)
    self.update_attributes(home_runs_scored: home_runs_scored_string)
    self.update_attributes(home_hits: home_hits_string)
    self.update_attributes(home_doubles: home_doubles_string)
    self.update_attributes(home_triples: home_triples_string)
    self.update_attributes(home_home_runs: home_home_runs_string)
    self.update_attributes(home_RBI: home_RBI_string)
    self.update_attributes(home_walks: home_walks_string)
    self.update_attributes(home_strikeouts: home_strikeouts_string)
    self.update_attributes(home_stolen_bases: home_stolen_bases_string)
    self.update_attributes(home_caught_stealing: home_caught_stealing_string)
    self.update_attributes(home_errors: home_errors_string)
    self.update_attributes(home_assists: home_assists_string)
    self.update_attributes(home_putouts: home_putouts_string)
    self.update_attributes(home_chances: home_chances_string)

    # away batting stats
    self.update_attributes(away_atbats: away_at_bats_string)
    self.update_attributes(away_runs_scored: away_runs_scored_string)
    self.update_attributes(away_hits: away_hits_string)
    self.update_attributes(away_doubles: away_doubles_string)
    self.update_attributes(away_triples: away_triples_string)
    self.update_attributes(away_home_runs: away_home_runs_string)
    self.update_attributes(away_RBI: away_RBI_string)
    self.update_attributes(away_walks: away_walks_string)
    self.update_attributes(away_strikeouts: away_strikeouts_string)
    self.update_attributes(away_stolen_bases: away_stolen_bases_string)
    self.update_attributes(away_caught_stealing: away_caught_stealing_string)
    self.update_attributes(away_errors: away_errors_string)
    self.update_attributes(away_assists: away_assists_string)
    self.update_attributes(away_putouts: away_putouts_string)
    self.update_attributes(away_chances: away_chances_string)

    # away pitching stats
    self.update_attributes(away_outs_recorded: away_outs_recorded_string)
    self.update_attributes(away_hits_allowed: away_hits_allowed_string)
    self.update_attributes(away_runs_allowed: away_runs_allowed_string)
    self.update_attributes(away_earned_runs_allowed: away_earned_runs_allowed_string)
    self.update_attributes(away_walks_allowed: away_walks_allowed_string)
    self.update_attributes(away_strikeouts_recorded: away_strikeouts_recorded_string)
    self.update_attributes(away_home_runs_allowed: away_home_runs_allowed_string)
    self.update_attributes(away_total_pitches: away_total_pitches_string)
    self.update_attributes(away_strikes_thrown: away_strikes_thrown_string)
    self.update_attributes(away_balls_thrown: away_balls_thrown_string)
    self.update_attributes(away_intentional_walks_allowed: away_intentional_walks_allowed_string)

    # home pitching stats
    self.update_attributes(home_outs_recorded: home_outs_recorded_string)
    self.update_attributes(home_hits_allowed: home_hits_allowed_string)
    self.update_attributes(home_runs_allowed: home_runs_allowed_string)
    self.update_attributes(home_earned_runs_allowed: home_earned_runs_allowed_string)
    self.update_attributes(home_walks_allowed: home_walks_allowed_string)
    self.update_attributes(home_strikeouts_recorded: home_strikeouts_recorded_string)
    self.update_attributes(home_home_runs_allowed: home_home_runs_allowed_string)
    self.update_attributes(home_total_pitches: home_total_pitches_string)
    self.update_attributes(home_strikes_thrown: home_strikes_thrown_string)
    self.update_attributes(home_balls_thrown: home_balls_thrown_string)
    self.update_attributes(home_intentional_walks_allowed: home_intentional_walks_allowed_string)

    # play by play
    puts "setting play by play"
    # self.update_attributes(pbp: "lol")
    # self.update_attributes(test: "lol")
    self.update_attributes(play_by_play: @pbp)
    puts "play by play set"
  end

  # Creates instance variables to use in the game
  def prepare

    # home and away teams
    @home_team = Team.find(self.home_team_id)
    @away_team = Team.find(self.away_team_id)

    # put players on home team
    @home_team.players.each do |player|
      player.set_initial_stats
    end

    # put players on away team
    @away_team.players.each do |player|
      player.set_initial_stats
    end

    # heat map data
    @called_strike_percentages = CalledStrikePercentage.all
    @contact_percentages = ContactPercentage.all
    @pitch_locations = PitchLocation.all
    @swing_percentages = SwingPercentage.all
    @heat_maps = {:called_strike_percentages => @called_strike_percentages,
                  :contact_percentages => @contact_percentages,
                  :pitch_locations => @pitch_locations,
                  :swing_percentages => @swing_percentages}

    # stadium data
    self.stadium_name = @home_team.stadium
    self.attendance = rand(30000..60000)

    # lineups
    home_lineup_string = ""
    away_lineup_string = ""
    for i in 0..8 do
      home_lineup_string = home_lineup_string + "#{@home_team.find_player_by_lineup_index(i).id}"
      away_lineup_string = away_lineup_string + "#{@away_team.find_player_by_lineup_index(i).id}"
      if i < 8
        home_lineup_string = home_lineup_string + "_"
        away_lineup_string = away_lineup_string + "_"
      end
    end
    self.update_attributes(home_lineup: home_lineup_string)
    self.update_attributes(away_lineup: away_lineup_string)

  end

  def randomGaussian
		((rand() +
		rand() + rand() +
		rand() + rand() +
		rand()) - 3) / 3;
	end

  def generateDistribution(min, max, mean, stdev)
    counter = 0
    idealMean = mean
    idealStdev = stdev
    numDataPts = 100
    bias = 0
    skew = 1
    randomData = calculateData(bias, skew, min, max, mean, stdev, numDataPts)
    newMean = calculateMean(randomData)
    newStdev = calculateStDev(randomData)
    meanError = idealMean/newMean
    stdevError = idealStdev/newStdev
    while meanError > 1.01 || meanError < 0.99 || stdevError > 1.01 || stdevError < 0.99 do
      if meanError > 1.01
        bias += 0.1
      elsif meanError < 0.99
        bias -= 0.1
      end
      if stdevError > 1.1
        skew *= 0.9
      elsif stdevError < 0.9
        skew *= 1.1
      end
      randomData = calculateData(bias, skew, min, max, mean, stdev, numDataPts)
      newMean = calculateMean(randomData)
      newStdev = calculateStDev(randomData)
      meanError = idealMean/newMean
      stdevError = idealStdev/newStdev
      counter = counter + 1
      if counter > 99
        break
      end
    end
    randomData
  end

  # random values from a distribution with a given min, max, mean, stdev
  def getRandomValue(bias, skew, min, max, mean, stdev)
    range = max - min
    mid = min + range/2
    unitGaussian = randomGaussian
    biasFactor = Math.exp(bias)
    value = (mid + (range * (biasFactor / (biasFactor + Math.exp(-unitGaussian / skew)) - 0.5)))
  end

  def calculateData(bias, skew, min, max, mean, stdev, numDataPts)
    randomData = Array.new(numDataPts)
    for i in 0..numDataPts-1
      randomData[i] = getRandomValue(bias, skew, min, max, mean, stdev)
    end
    randomData
  end

  def calculateMean(randomData)
    numDataPts = randomData.length
    sum = 0
    for i in 0..numDataPts-1
      sum += randomData[i]
    end
    mean = sum/numDataPts
  end

  def calculateStDev(randomData)
    numDataPts = randomData.length
    mean = calculateMean(randomData)
    sum = 0
    for i in 0..numDataPts-1
      sum += (randomData[i] - mean) ** 2
    end
    stdev = Math.sqrt(sum/numDataPts)
  end

end
