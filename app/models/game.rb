class Game < ActiveRecord::Base
  validate :teams_must_be_different
  attr_accessor :home_team, :away_team, :pitch_locations, :heat_maps, :inning_status, :away_team_lineup_position, :home_team_lineup_position, :away_team_score, :home_team_score

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

    # Simulate game
    while @inning_number < 10 do
      # Top of inning
      puts "\nTop of inning #{@inning_number} (#{@away_team.full_name} batting):\n"
      @inning_status = InningStatus::TOP
      inning = Inning.new(self)
      # Bottom of inning
      puts "\nBottom of inning #{@inning_number} (#{@home_team.full_name} batting):"
      @inning_status = InningStatus::BOTTOM
      inning = Inning.new(self)
      @inning_number = @inning_number + 1
    end
    puts "Game over"
    collect_stats
  end

  def collect_stats
    # at bats
    home_at_bats_string = ""
    away_at_bats_string = ""
    for i in 0..8 do
      home_at_bats_string = home_at_bats_string + "#{@home_team.find_player_by_lineup_index(i).at_bats}"
      away_at_bats_string = away_at_bats_string + "#{@away_team.find_player_by_lineup_index(i).at_bats}"
      if i < 8
        home_at_bats_string = home_at_bats_string + "_"
        away_at_bats_string = away_at_bats_string + "_"
      end
    end
    self.update_attributes(home_atbats: home_at_bats_string)
    self.update_attributes(away_atbats: away_at_bats_string)
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
