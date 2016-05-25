class AtBat
  attr_accessor :result, :balls, :strikes, :over
  def initialize(pitcher, batter, heat_maps)
    @balls = 0
    @strikes = 0
    @over = false
    @pitcher = pitcher
    @batter = batter
    @heat_maps = heat_maps
    @result = AtBatResult::IN_PROGRESS

    puts "Now batting: #{@batter.full_name}"
    # Simulate at-bat
    while !@over do
      pitch = Pitch.new(@pitcher, @batter, @balls, @strikes, @heat_maps)
      if batterSwingsAt(pitch)
        if batterMakesContactWith(pitch)
          if ballIsHitFair
            fairBall
          else
            foulBall
          end
        else
          swingAndAMiss
        end
      else
        batterDoesntSwingAt(pitch)
      end
    end
  end

  # Returns true if the batter swings at a pitch
  def batterSwingsAt(pitch)
    rand(100) < pitch.swing_percentage
  end

  # Returns true if the batter makes contact with a pitch
  def batterMakesContactWith(pitch)
    rand(100) < pitch.contact_percentage
  end

  # Returns true if the ball is hit in fair territory
  def ballIsHitFair
    percent_foul = 0.42
    rand() > percent_foul
  end

  # Batter hits the ball in fair territory
  def fairBall
    @over = true
    @result = AtBatResult::PUT_IN_PLAY
  end

  # Batter hits a foul ball
  def foulBall
    if @strikes < 2
      @strikes = @strikes + 1
    end
  end

  # Batter swings and misses
  def swingAndAMiss
    if @strikes < 2
      @strikes = @strikes + 1
    else
      strikeout
    end
  end

  # Batter doesn't swing
  def batterDoesntSwingAt(pitch)
    if isStrike(pitch)
      batterTakesStrike
    else
      batterTakesBall
    end
  end

  # Batter doesn't swing, pitch is a strike
  def batterTakesStrike
    if @strikes < 2
      @strikes = @strikes + 1
    else
      strikeout
    end
  end

  # Batter doesn't swing, pitch is a ball
  def batterTakesBall
    if @balls < 3
      @balls = @balls + 1
    else
      walk
    end
  end

  # Batter walks
  def walk
    @over = true
    @result = AtBatResult::WALK
  end

  # Batter strikes out
  def strikeout
    @over = true
    @result = AtBatResult::STRIKEOUT
  end

  # Is the pitch a strike?
  def isStrike(pitch)
    rand(100) < pitch.called_strike_percentage
  end

end
