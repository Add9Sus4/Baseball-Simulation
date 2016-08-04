class AtBat
  include Reusable
  attr_accessor :result, :balls, :strikes, :over, :batter
  def initialize(pitcher, batter, game, bases)
    @bases = bases
    @balls = 0
    @strikes = 0
    @over = false
    @pitcher = pitcher
    @batter = batter
    @result = AtBatResult::IN_PROGRESS
    @game = game
    @game.play_by_play += "\n<span>Now batting: #{@batter.full_name}</span>\n"
    # @game.play_by_play += "\nNow batting: #{@batter.full_name}"
    # Simulate at-bat
    while !@over do
      @pitch = Pitch.new(@pitcher, @batter, @balls, @strikes)
      if batterSwingsAt(@pitch)
        @pitcher.throws_strike
        if batterMakesContactWith(@pitch)
          if ballIsHitFair
            @game.play_by_play += "\n<span style=\"font-size:8px\">Fastball #{@pitch.location_type}, hit in play.</span>\n"
            fairBall
          else
            foulBall
          end
        else
          swingAndAMiss
        end
      else
        batterDoesntSwingAt(@pitch)
      end
    end
  end

  # Calculates if a runner tries to steal a base
  def steal_opportunity
    if @bases.status == BaseStatus::RUNNER_ON_FIRST || @bases.status == BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      if rand() > map_attribute_to_range(@bases.runner_on_first.speed, AttributeAdjustments::RUNNER_SPEED_AFFECTS_STEAL_PROBABILITY_MIN, AttributeAdjustments::RUNNER_SPEED_AFFECTS_STEAL_PROBABILITY_MAX, true)
        @bases.runner_on_first_steals_second
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
    @batter.logs_at_bat
    @over = true
    @result = AtBatResult::PUT_IN_PLAY
  end

  # Batter hits a foul ball
  def foulBall
    if @strikes < 2
      @strikes = @strikes + 1
    end
    @game.play_by_play += "\n<span style=\"font-size:8px\">Fastball #{@pitch.location_type}, fouled off. Count: #{@balls}-#{@strikes}</span>\n"
  end

  # Batter swings and misses
  def swingAndAMiss
    if @strikes < 2
      @strikes = @strikes + 1
      @game.play_by_play += "\n<span style=\"font-size:8px\">Fastball #{@pitch.location_type}, swing and a miss. Count: #{@balls}-#{@strikes}</span>\n"
      steal_opportunity
    else
      @game.play_by_play += "\n<span style=\"font-size:8px\">Fastball #{@pitch.location_type}, swing and a miss for strike 3.</span>\n"
      strikeout
    end
  end

  # Batter doesn't swing
  def batterDoesntSwingAt(pitch)
    if isStrike(pitch)
      batterTakesStrike
      @pitcher.throws_strike
    else
      batterTakesBall
      @pitcher.throws_ball
    end
  end

  # Batter doesn't swing, pitch is a strike
  def batterTakesStrike
    if @strikes < 2
      @strikes = @strikes + 1
      @game.play_by_play += "\n<span style=\"font-size:8px\">Fastball #{@pitch.location_type}, taken for a strike. Count: #{@balls}-#{@strikes}</span>\n"
      steal_opportunity
    else
      @game.play_by_play += "\n<span style=\"font-size:8px\">Fastball #{@pitch.location_type}, taken for strike 3.</span>\n"
      strikeout
    end
  end

  # Batter doesn't swing, pitch is a ball
  def batterTakesBall
    if @balls < 3
      @balls = @balls + 1
      @game.play_by_play += "\n<span style=\"font-size:8px\">Fastball #{@pitch.location_type}, taken for a ball. Count: #{@balls}-#{@strikes}</span>\n"
      steal_opportunity
    else
      @game.play_by_play += "\n<span style=\"font-size:8px\">Fastball #{@pitch.location_type}, taken for ball 4.</span>\n"
      walk
    end
  end

  # Batter walks
  def walk
    @game.play_by_play += "\n<span style=\"color:" + @game.good + "\">#{@batter.full_name} walks.</span>\n"
    @pitcher.allows_walk
    @batter.receives_walk
    @over = true
    @result = AtBatResult::WALK
  end

  # Batter strikes out
  def strikeout
    @game.play_by_play += "\n<span style=\"color:" + @game.bad + "\">#{@batter.full_name} strikes out.</span>\n"
    @pitcher.records_strikeout
    @batter.strikes_out
    @batter.logs_at_bat
    @over = true
    @result = AtBatResult::STRIKEOUT
  end

  # Is the pitch a strike?
  def isStrike(pitch)
    rand(100) < pitch.called_strike_percentage
  end

end
