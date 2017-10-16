require 'spec_helper'


@batter = FactoryGirl.build_stubbed(:player, :average)
@pitcher = FactoryGirl.build_stubbed(:player, :average)

@batter.set_initial_stats
@pitcher.set_initial_stats
@batter.plate_vision = 100

num_strikes = 0
num_balls = 0

# Test for strike to ball ratio
10000.times do

  @pitch = Pitch.new(@pitcher, @batter, 0, 0)

  case @pitch.result
  when PitchResult::TAKEN_FOR_STRIKE, PitchResult::SWINGING_STRIKE, PitchResult::FOUL_BALL, PitchResult::HIT_IN_PLAY
    num_strikes += 1
  when PitchResult::TAKEN_FOR_BALL
    num_balls += 1
  end

end

puts "Strikes: #{num_strikes}"
puts "Balls: #{num_balls}"
puts "Percent Strikes: #{num_strikes.to_f/10000.0}"

Player.delete_all
Team.delete_all
