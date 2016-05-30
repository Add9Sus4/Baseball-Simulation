class Pitch
  attr_accessor :heat_maps, :location, :swing_percentage, :contact_percentage, :called_strike_percentage, :location_type
  def initialize(pitcher, batter, balls, strikes, heat_maps)
    @pitcher = pitcher
    @batter = batter
    @balls = balls
    @strikes = strikes
    @heat_maps = heat_maps
    # Calculate pitch location (which zone it will be in)
    @location = determine_location(rand(), "LEFT", "RIGHT", @balls, @strikes, "FA")
    @location_type = determine_location_type("RIGHT", @location)
    # Will batter swing?
    @swing_percentage = determine_swing_percentage(@location, "LEFT", "RIGHT", @balls, @strikes, "FA")
    # Will batter make contact?
    @contact_percentage = determine_contact_percentage(@location, "LEFT", "RIGHT", @balls, @strikes, "FA")
    # Will the pitch be called a strike?
    @called_strike_percentage = determine_called_strike_percentage(@location, "LEFT", "RIGHT", @balls, @strikes, "FA")
    @pitcher.throws_pitch(@location)
  end

  # Retrieve called strike percentage
  def determine_called_strike_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    key = "#{zone_id}_#{pitcher_hand}_#{batter_hand}_#{balls}_#{strikes}_#{pitch_type}"
    @heat_maps.called_strike_percentages[key]
    # @heat_maps[:called_strike_percentages].where(zone_id: zone_id, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
  end

  # Retrieve contact percentage
  def determine_contact_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    key = "#{zone_id}_#{pitcher_hand}_#{batter_hand}_#{balls}_#{strikes}_#{pitch_type}"
    @heat_maps.contact_percentages[key]
    # @heat_maps[:contact_percentages].where(zone_id: zone_id, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
  end

  # Retrieve pitch location (which zone the pitch will be in)
  # NOTE: random_between_0_and_1 is a variable that holds a random number between 0 and 1 (use rand() to generate)
  def determine_location(random_between_0_and_1, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    zone_percentages = Array.new(72)
    count = 1
    sum = 0
    # Get the pitch location percentages for each zone
    72.times do # count 1 to 72
      key = "#{count}_#{pitcher_hand}_#{batter_hand}_#{balls}_#{strikes}_#{pitch_type}"
      zone_percentages[count] = @heat_maps.pitch_locations[key]*location_adjustment(@pitcher, count) # adjust for pitcher control and location attributes
      # zone_percentages[count] = @heat_maps[:pitch_locations].where(zone_id: count, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
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

  # Returns true if a heat map index is inside the strike zone
  def is_in_strike_zone(index)
    case index
    when 13..18, 21..26, 30..35, 39..44, 47..52, 55..60
      true
    else
      false
    end
  end

  # Adjusts location probabilities based on pitcher control attribute
  def control_adjustment(pitcher, index)
    control_multiplier = 1
    if pitcher.control > 50
      control_multiplier = pitcher.control.to_f/50 # 1 to 2
    else
      control_multiplier = (pitcher.control + 50).to_f/100 # 0.5 to 1
    end
    if is_in_strike_zone(index)
      control_multiplier
    else
      1/control_multiplier
    end
  end

  # Returns true if a heat map index is near the edge of the strike zone
  def is_close_to_edge(index)
    case index
    when 4..21, 26, 27, 29, 30, 35, 36, 38, 39, 44..47, 52..69
      true
    else
      false
    end
  end

  # Adjusts location probabilities based on pitcher location attribute
  def location_adjustment(pitcher, index)
    location_multiplier = 1
    if pitcher.location > 50
      location_multiplier = pitcher.location.to_f/50 # 1 to 2
    else
      location_multiplier = (pitcher.location + 50).to_f/100 # 0.5 to 1
    end
    if is_close_to_edge(index)
      location_multiplier
    else
      1/location_multiplier
    end
  end

  # Given the zone_number of the pitch and the batter's handedness, determine the pitch location type (as defined in PitchLocationType)
  def determine_location_type(batter_hand, zone_number)
    case zone_number
    # If the pitch is a ball
    when 1
      batter_hand == "LEFT" ? PitchLocationType::WAY_HIGH_AND_OUTSIDE : PitchLocationType::WAY_HIGH_AND_INSIDE
    when 2
      PitchLocationType::WAY_HIGH
    when 3
      batter_hand == "LEFT" ? PitchLocationType::WAY_HIGH_AND_INSIDE : PitchLocationType::WAY_HIGH_AND_OUTSIDE
    when 4, 5, 12
      batter_hand == "LEFT" ? PitchLocationType::JUST_HIGH_AND_OUTSIDE : PitchLocationType::JUST_HIGH_AND_INSIDE
    when 6..9
      PitchLocationType::JUST_HIGH
    when 10, 11, 19
      batter_hand == "LEFT" ? PitchLocationType::JUST_HIGH_AND_INSIDE : PitchLocationType::JUST_HIGH_AND_OUTSIDE
    when 28
      batter_hand == "LEFT" ? PitchLocationType::WAY_OUTSIDE : PitchLocationType::WAY_INSIDE
    when 20, 29, 38, 46
      batter_hand == "LEFT" ? PitchLocationType::JUST_OUTSIDE : PitchLocationType::JUST_INSIDE
    when 27, 36, 45, 53
      batter_hand == "LEFT" ? PitchLocationType::JUST_INSIDE : PitchLocationType::JUST_OUTSIDE
    when 37
      batter_hand == "LEFT" ? PitchLocationType::WAY_INSIDE : PitchLocationType::WAY_OUTSIDE
    when 70
      batter_hand == "LEFT" ? PitchLocationType::WAY_LOW_AND_OUTSIDE : PitchLocationType::WAY_LOW_AND_INSIDE
    when 54, 62, 63
      batter_hand == "LEFT" ? PitchLocationType::JUST_LOW_AND_OUTSIDE : PitchLocationType::JUST_LOW_AND_INSIDE
    when 64..67
      PitchLocationType::JUST_LOW
    when 61, 68, 69
      batter_hand == "LEFT" ? PitchLocationType::JUST_LOW_AND_INSIDE : PitchLocationType::JUST_LOW_AND_OUTSIDE
    when 72
      batter_hand == "LEFT" ? PitchLocationType::WAY_LOW_AND_INSIDE : PitchLocationType::WAY_LOW_AND_OUTSIDE
    # If the pitch is a strike
    when 13, 14, 21
      batter_hand == "LEFT" ? PitchLocationType::AT_THE_LETTERS_ON_THE_OUTSIDE_CORNER : PitchLocationType::AT_THE_LETTERS_ON_THE_INSIDE_CORNER
    when 15, 16
      PitchLocationType::AT_THE_LETTERS
    when 17, 18, 26
      batter_hand == "LEFT" ? PitchLocationType::AT_THE_LETTERS_ON_THE_INSIDE_CORNER : PitchLocationType::AT_THE_LETTERS_ON_THE_OUTSIDE_CORNER
    when 30, 39
      batter_hand == "LEFT" ? PitchLocationType::ON_THE_OUTSIDE_CORNER : PitchLocationType::ON_THE_INSIDE_CORNER
    when 35, 44
      batter_hand == "LEFT" ? PitchLocationType::ON_THE_INSIDE_CORNER : PitchLocationType::ON_THE_OUTSIDE_CORNER
    when 47, 55, 56
      batter_hand == "LEFT" ? PitchLocationType::AT_THE_KNEES_ON_THE_OUTSIDE_CORNER : PitchLocationType::AT_THE_KNEES_ON_THE_INSIDE_CORNER
    when 57, 58
      PitchLocationType::AT_THE_KNEES
    when 52, 59, 60
      batter_hand == "LEFT" ? PitchLocationType::AT_THE_KNEES_ON_THE_INSIDE_CORNER : PitchLocationType::AT_THE_KNEES_ON_THE_OUTSIDE_CORNER
    when 22
      batter_hand == "LEFT" ? PitchLocationType::ON_THE_UPPER_OUTER_HALF : PitchLocationType::ON_THE_UPPER_INNER_HALF
    when 25
      batter_hand == "LEFT" ? PitchLocationType::ON_THE_UPPER_INNER_HALF : PitchLocationType::ON_THE_UPPER_OUTER_HALF
    when 48
      batter_hand == "LEFT" ? PitchLocationType::ON_THE_LOWER_OUTER_HALF : PitchLocationType::ON_THE_LOWER_INNER_HALF
    when 51
      batter_hand == "LEFT" ? PitchLocationType::ON_THE_LOWER_INNER_HALF : PitchLocationType::ON_THE_LOWER_OUTER_HALF
    when 23, 24
      PitchLocationType::ON_THE_UPPER_HALF
    when 49, 50
      PitchLocationType::ON_THE_LOWER_HALF
    when 31, 40
      batter_hand == "LEFT" ? PitchLocationType::ON_THE_OUTER_HALF : PitchLocationType::ON_THE_INNER_HALF
    when 34, 43
      batter_hand == "LEFT" ? PitchLocationType::ON_THE_INNER_HALF : PitchLocationType::ON_THE_OUTER_HALF
    when 32, 33, 41, 42
      PitchLocationType::DOWN_THE_MIDDLE
    end
  end

  # Retrieve swing percentage
  def determine_swing_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    key = "#{zone_id}_#{pitcher_hand}_#{batter_hand}_#{balls}_#{strikes}_#{pitch_type}"
    @heat_maps.swing_percentages[key]
    # @heat_maps[:swing_percentages].where(zone_id: zone_id, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
  end
end
