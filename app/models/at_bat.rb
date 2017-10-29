# The at-bat class.
class AtBat

  # Include some mathematical functions
  include Reusable

  # Various attributes that need to be accessed by other classes
  attr_accessor :result, :balls, :strikes, :over, :batter, :play_by_play, :fielding_team, :pitcher

  # Start the at-bat
  def initialize(pitcher, batter, fielding_team, bases)
    @play_by_play = ""
    @bases = bases
    @fielding_team = fielding_team
    @balls = 0
    @strikes = 0
    @over = false
    @pitcher = pitcher
    @batter = batter
    @result = AtBatResult::IN_PROGRESS
    @play_by_play += "\n<span>Now batting: #{@batter.full_name}</span>\n"

    # Simulate at-bat
    while !@over do
      @pitch = Pitch.new(@pitcher, @batter, @balls, @strikes)
      case @pitch.result
      when PitchResult::HIT_IN_PLAY
        hitInPlay
      when PitchResult::TAKEN_FOR_STRIKE
        takenForStrike
      when PitchResult::TAKEN_FOR_BALL
        takenForBall
      when PitchResult::SWINGING_STRIKE
        swingingStrike
      when PitchResult::FOUL_BALL
        foulBall
      end
    end
  end

  # Determine if a runner tries to steal a base (TODO: Implement caught stealing functionality. Right now, steals are always successful)
  def steal_opportunity
    if @bases.status == BaseStatus::RUNNER_ON_FIRST || @bases.status == BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      if rand() > map_attribute_to_range(@bases.runner_on_first.speed, AttributeAdjustments::RUNNER_SPEED_AFFECTS_STEAL_PROBABILITY_MIN, AttributeAdjustments::RUNNER_SPEED_AFFECTS_STEAL_PROBABILITY_MAX, true)
        @bases.runner_on_first_steals_second
        @play_by_play += @bases.play_by_play
      end
    end
  end

  # Batter hits the ball in fair territory
  def hitInPlay
    @pitcher.throws_strike
    @play_by_play += "\n<span style=\"font-size:8px\">#{@pitch.speed.to_i} mph #{@pitch.type_name} #{@pitch.location_type}, hit in play.</span>\n"
    @batter.logs_at_bat
    @over = true
    @result = AtBatResult::PUT_IN_PLAY
  end

  # Batter hits a foul ball
  def foulBall
    @pitcher.throws_strike
    if @strikes < 2
      @strikes = @strikes + 1
    end
    # TODO: create different types of foul balls (fouled off to the left, fouled back to the screen, etc... maybe based on quality of contact, pull amount, etc.)
    @play_by_play += "\n<span style=\"font-size:8px\">#{@pitch.speed.to_i} mph #{@pitch.type_name} #{@pitch.location_type}, fouled off. Count: #{@balls}-#{@strikes}</span>\n"
  end

  # Batter swings and misses
  def swingingStrike
    @pitcher.throws_strike
    if @strikes < 2
      @strikes = @strikes + 1
      @play_by_play += "\n<span style=\"font-size:8px\">#{@pitch.speed.to_i} mph #{@pitch.type_name} #{@pitch.location_type}, swing and a miss. Count: #{@balls}-#{@strikes}</span>\n"
      steal_opportunity
    else
      @play_by_play += "\n<span style=\"font-size:8px\">#{@pitch.speed.to_i} mph #{@pitch.type_name} #{@pitch.location_type}, swing and a miss for strike 3.</span>\n"
      strikeout
    end
  end

  # Batter doesn't swing, pitch is a strike
  def takenForStrike
    @pitcher.throws_strike
    if @strikes < 2
      @strikes = @strikes + 1
      @play_by_play += "\n<span style=\"font-size:8px\">#{@pitch.speed.to_i} mph #{@pitch.type_name} #{@pitch.location_type}, taken for a strike. Count: #{@balls}-#{@strikes}</span>\n"
      steal_opportunity
    else
      @play_by_play += "\n<span style=\"font-size:8px\">#{@pitch.speed.to_i} mph #{@pitch.type_name} #{@pitch.location_type}, taken for strike 3.</span>\n"
      strikeout # TODO: allow players to steal on a strikeout, unless it's the third out of the inning.
    end
  end

  # Batter doesn't swing, pitch is a ball
  def takenForBall
    @pitcher.throws_ball
    if @balls < 3
      @balls = @balls + 1
      @play_by_play += "\n<span style=\"font-size:8px\">#{@pitch.speed.to_i} mph #{@pitch.type_name} #{@pitch.location_type}, taken for a ball. Count: #{@balls}-#{@strikes}</span>\n"
      steal_opportunity
    else
      @play_by_play += "\n<span style=\"font-size:8px\">#{@pitch.speed.to_i} mph #{@pitch.type_name} #{@pitch.location_type}, taken for ball 4.</span>\n"
      walk
    end
  end

  # Batter walks
  def walk
    @play_by_play += "\n<span style=\"color:" + color_good + "\">#{@batter.full_name} walks.</span>\n"
    @pitcher.allows_walk
    @batter.receives_walk
    @over = true
    @result = AtBatResult::WALK
  end

  # Batter strikes out
  def strikeout
    @play_by_play += "\n<span style=\"color:" + color_bad + "\">#{@batter.full_name} strikes out.</span>\n"
    @pitcher.records_strikeout
    @batter.strikes_out
    @batter.logs_at_bat
    @over = true
    @result = AtBatResult::STRIKEOUT
  end

end
