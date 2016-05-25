class Pitch
  attr_accessor :heat_maps, :location, :swing_percentage, :contact_percentage, :called_strike_percentage
  def initialize(pitcher, batter, balls, strikes, heat_maps)
    @pitcher = pitcher
    @batter = batter
    @balls = balls
    @strikes = strikes
    @heat_maps = heat_maps
    # Calculate pitch location (which zone it will be in)
    @location = determine_location(rand(), "LEFT", "RIGHT", @balls, @strikes, "FA")
    # Will batter swing?
    @swing_percentage = determine_swing_percentage(@location, "LEFT", "RIGHT", @balls, @strikes, "FA")
    # Will batter make contact?
    @contact_percentage = determine_contact_percentage(@location, "LEFT", "RIGHT", @balls, @strikes, "FA")
    # Will the pitch be called a strike?
    @called_strike_percentage = determine_called_strike_percentage(@location, "LEFT", "RIGHT", @balls, @strikes, "FA")
    @pitcher.throws_pitch
  end

  # Retrieve called strike percentage
  def determine_called_strike_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    @heat_maps[:called_strike_percentages].where(zone_id: zone_id, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
  end

  # Retrieve contact percentage
  def determine_contact_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    @heat_maps[:contact_percentages].where(zone_id: zone_id, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
  end

  # Retrieve pitch location (which zone the pitch will be in)
  # NOTE: random_between_0_and_1 is a variable that holds a random number between 0 and 1 (use rand() to generate)
  def determine_location(random_between_0_and_1, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    zone_percentages = Array.new(72)
    count = 1
    sum = 0
    # Get the pitch location percentages for each zone
    72.times do
      zone_percentages[count] = @heat_maps[:pitch_locations].where(zone_id: count, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
      sum += zone_percentages[count]
      count = count + 1
    end

    # Calculate which zone the pitch will be in, based on the percentages
    random_val = random_between_0_and_1 * sum
    count = 1
    sum = 0
    while random_val > sum do
      sum += zone_percentages[count]
      count = count + 1
    end
    count - 1 # Return the correct zone
  end

  # Retrieve swing percentage
  def determine_swing_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    @heat_maps[:swing_percentages].where(zone_id: zone_id, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
  end
end
