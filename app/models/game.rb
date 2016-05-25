class Game < ActiveRecord::Base
  validate :teams_must_be_different
  attr_accessor :home_team, :away_team, :pitch_locations, :heat_maps

  def teams_must_be_different
    errors.add(:base, "Teams cannot be the same") if home_team_id == away_team_id
  end

  def atBat
    atBat = AtBat.new(@home_team.players[0], @away_team.players[0], @heat_maps)
  end

  # Plays a game
  def play
    prepare
    @over = false
    @inning_number = 1
    @inning_status = InningStatus::TOP

    # Simulate game
    while @inning_number < 10 do
      # Top of inning
      puts "Top of inning #{@inning_number}:"
      @inning_status = InningStatus::TOP
      inning = Inning.new(@away_team, @home_team, @heat_maps)
      # Bottom of inning
      puts "Bottom of inning #{@inning_number}:"
      @inning_status = InningStatus::BOTTOM
      inning = Inning.new(@home_team, @away_team, @heat_maps)
      @inning_number = @inning_number + 1
    end
    puts "Game over"
  end

  # Creates instance variables to use in the game
  def prepare()

    # home and away teams
    @home_team = Team.find(self.home_team_id)
    @away_team = Team.find(self.away_team_id)

    # home and away players
    @home_players = []
    @away_players = []

    # put players on home team
    @home_team.players.each do |player|
      @home_players.push(player)
    end

    # put players on away team
    @away_team.players.each do |player|
      @away_players.push(player)
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
