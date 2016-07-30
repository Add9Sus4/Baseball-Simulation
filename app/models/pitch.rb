class Pitch
  include Reusable
  attr_accessor :location, :swing_percentage, :contact_percentage, :called_strike_percentage, :location_type
  def initialize(pitcher, batter, balls, strikes)
    @pitcher = pitcher
    @batter = batter
    @balls = balls
    @strikes = strikes
    # Calculate pitch location (which zone it will be in)
    @location = determine_location(@pitcher.throwing_hand, @batter.hitting_side, @balls, @strikes, "FA")
    @location_type = determine_location_type(@batter.hitting_side, @location)
    # Will batter swing?
    @swing_percentage = determine_swing_percentage(@location, @pitcher.throwing_hand, @batter.hitting_side, @balls, @strikes, "FA")
    # Will batter make contact?
    @contact_percentage = determine_contact_percentage(@location, @pitcher.throwing_hand, @batter.hitting_side, @balls, @strikes, "FA")
    # Will the pitch be called a strike?
    @called_strike_percentage = determine_called_strike_percentage(@location, @pitcher.throwing_hand, @batter.hitting_side, @balls, @strikes, "FA")
    @pitcher.throws_pitch(@location)
  end

  # Retrieve called strike percentage
  def determine_called_strike_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)

    if is_down_the_middle(zone_id)
      100
    elsif is_between_edge_and_middle(zone_id)
      98
    elsif is_close_to_edge(zone_id)
      70
    elsif is_just_off_the_edge(zone_id)
      15
    elsif is_way_off_the_edge(zone_id)
      0
    end

    # key = "#{zone_id}_#{pitcher_hand}_#{batter_hand}_#{balls}_#{strikes}_#{pitch_type}"
    # @heat_maps.called_strike_percentages[key]
    # # @heat_maps[:called_strike_percentages].where(zone_id: zone_id, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
  end

  # Retrieve contact percentage
  def determine_contact_percentage(zone_id, pitcher_hand, batter_hand, balls, strikes, pitch_type)
    contact_percentage = 1
    if is_down_the_middle(zone_id)
      contact_percentage = 95
    elsif is_between_edge_and_middle(zone_id)
      contact_percentage = 90
    elsif is_close_to_edge(zone_id)
      contact_percentage = 85
    elsif is_just_off_the_edge(zone_id)
      contact_percentage = 80
    elsif is_way_off_the_edge(zone_id)
      contact_percentage = 60
    end

    contact_percentage *= map_attribute_to_range(@batter.contact, AttributeAdjustments::BATTER_CONTACT_AFFECTS_CONTACT_PERCENTAGE_MIN, AttributeAdjustments::BATTER_CONTACT_AFFECTS_CONTACT_PERCENTAGE_MAX, false)*
      map_attribute_to_range(@pitcher.armStrength, AttributeAdjustments::PITCHER_ARM_STRENGTH_AFFECTS_CONTACT_PERCENTAGE_MIN, AttributeAdjustments::PITCHER_ARM_STRENGTH_AFFECTS_CONTACT_PERCENTAGE_MAX, true)*
      map_attribute_to_range(@pitcher.movement, AttributeAdjustments::PITCHER_MOVEMENT_AFFECTS_CONTACT_PERCENTAGE_MIN, AttributeAdjustments::PITCHER_MOVEMENT_AFFECTS_CONTACT_PERCENTAGE_MAX, true)
    # key = "#{zone_id}_#{pitcher_hand}_#{batter_hand}_#{balls}_#{strikes}_#{pitch_type}"
    # @heat_maps.contact_percentages[key]*
    #   map_attribute_to_range(@batter.contact, AttributeAdjustments::BATTER_CONTACT_AFFECTS_CONTACT_PERCENTAGE_MIN, AttributeAdjustments::BATTER_CONTACT_AFFECTS_CONTACT_PERCENTAGE_MAX, false)*
    #   map_attribute_to_range(@pitcher.armStrength, AttributeAdjustments::PITCHER_ARM_STRENGTH_AFFECTS_CONTACT_PERCENTAGE_MIN, AttributeAdjustments::PITCHER_ARM_STRENGTH_AFFECTS_CONTACT_PERCENTAGE_MAX, true)*
    #   map_attribute_to_range(@pitcher.movement, AttributeAdjustments::PITCHER_MOVEMENT_AFFECTS_CONTACT_PERCENTAGE_MIN, AttributeAdjustments::PITCHER_MOVEMENT_AFFECTS_CONTACT_PERCENTAGE_MAX, true)
    # # @heat_maps[:contact_percentages].where(zone_id: zone_id, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
  end

  # This method takes an x, y coordinate where the pitcher throws the ball and calculates
  # the zone that this ball will be located in
  def coordinate_to_zone(targets)

    x = targets[0]
    y = targets[1]

    case x
    when 0.0..0.1

      case y
      when 0.0..0.3
        1
      when 0.3..0.7
        28
      when 0.7..1.0
        70
      end

    when 0.1..0.2

      case y
      when 0.0..0.1
        1
      when 0.1..0.2
        4
      when 0.2..0.3
        12
      when 0.3..0.4
        20
      when 0.4..0.5
        29
      when 0.5..0.6
        38
      when 0.6..0.7
        46
      when 0.7..0.8
        54
      when 0.8..0.9
        62
      when 0.9..1.0
        70
      end

    when 0.2..0.3

      case y
      when 0.0..0.1
        1
      when 0.1..0.2
        5
      when 0.2..0.3
        13
      when 0.3..0.4
        21
      when 0.4..0.5
        30
      when 0.5..0.6
        39
      when 0.6..0.7
        47
      when 0.7..0.8
        55
      when 0.8..0.9
        63
      when 0.9..1.0
        70
      end

    when 0.3..0.4

      case y
      when 0.0..0.1
        2
      when 0.1..0.2
        6
      when 0.2..0.3
        14
      when 0.3..0.4
        22
      when 0.4..0.5
        31
      when 0.5..0.6
        40
      when 0.6..0.7
        48
      when 0.7..0.8
        56
      when 0.8..0.9
        64
      when 0.9..1.0
        71
      end

    when 0.4..0.5

      case y
      when 0.0..0.1
        2
      when 0.1..0.2
        7
      when 0.2..0.3
        15
      when 0.3..0.4
        23
      when 0.4..0.5
        32
      when 0.5..0.6
        41
      when 0.6..0.7
        49
      when 0.7..0.8
        57
      when 0.8..0.9
        65
      when 0.9..1.0
        71
      end

    when 0.5..0.6

      case y
      when 0.0..0.1
        2
      when 0.1..0.2
        8
      when 0.2..0.3
        16
      when 0.3..0.4
        24
      when 0.4..0.5
        33
      when 0.5..0.6
        42
      when 0.6..0.7
        50
      when 0.7..0.8
        58
      when 0.8..0.9
        66
      when 0.9..1.0
        71
      end

    when 0.6..0.7

      case y
      when 0.0..0.1
        2
      when 0.1..0.2
        9
      when 0.2..0.3
        17
      when 0.3..0.4
        25
      when 0.4..0.5
        34
      when 0.5..0.6
        43
      when 0.6..0.7
        51
      when 0.7..0.8
        59
      when 0.8..0.9
        67
      when 0.9..1.0
        71
      end

    when 0.7..0.8

      case y
      when 0.0..0.1
        3
      when 0.1..0.2
        10
      when 0.2..0.3
        18
      when 0.3..0.4
        26
      when 0.4..0.5
        35
      when 0.5..0.6
        44
      when 0.6..0.7
        52
      when 0.7..0.8
        60
      when 0.8..0.9
        68
      when 0.9..1.0
        72
      end

    when 0.8..0.9

      case y
      when 0.0..0.1
        3
      when 0.1..0.2
        11
      when 0.2..0.3
        19
      when 0.3..0.4
        27
      when 0.4..0.5
        36
      when 0.5..0.6
        45
      when 0.6..0.7
        53
      when 0.7..0.8
        61
      when 0.8..0.9
        69
      when 0.9..1.0
        72
      end

    when 0.9..1.0

      case y
      when 0.0..0.3
        3
      when 0.3..0.7
        37
      when 0.7..1.0
        72
      end

    end
  end

  def try_to_hit_just_off_the_edge()
    case rand()
    when 0.0..0.25 # just above the letters
      x_target = rand(0.2..0.8)
      y_target = rand(0.1..0.2)
    when 0.25..0.50 # just below the knees
      x_target = rand(0.2..0.8)
      y_target = rand(0.8..0.9)
    when 0.50..0.75 # just off the inside corner to RHB
      x_target = rand(0.1..0.2)
      y_target = rand(0.2..0.8)
    when 0.75..1.0 # just off the outside corner to RHB
      x_target = rand(0.8..0.9)
      y_target = rand(0.2..0.8)
    end
    [x_target, y_target]
  end

  def try_to_hit_the_edge()
    case rand()
    when 0.0..0.25 # at the letters
      x_target = rand(0.2..0.8)
      y_target = rand(0.2..0.3)
    when 0.25..0.50 # at the knees
      x_target = rand(0.2..0.8)
      y_target = rand(0.7..0.8)
    when 0.50..0.75 # inside corner to RHB
      x_target = rand(0.2..0.3)
      y_target = rand(0.2..0.8)
    when 0.75..1.0 # outside corner to RHB
      x_target = rand(0.7..0.8)
      y_target = rand(0.2..0.8)
    end
    [x_target, y_target]
  end

  def try_to_throw_strike()
    case rand()
    when 0.0..0.25 # upper half
      x_target = rand(0.2..0.8)
      y_target = rand(0.3..0.4)
    when 0.25..0.50 # lower half
      x_target = rand(0.2..0.8)
      y_target = rand(0.6..0.7)
    when 0.50..0.75 # inner half to RHB
      x_target = rand(0.3..0.4)
      y_target = rand(0.2..0.8)
    when 0.75..1.0 # outer half to RHB
      x_target = rand(0.6..0.7)
      y_target = rand(0.2..0.8)
    end
    [x_target, y_target]
  end

  # Determine pitch location (which zone the pitch will be in)
  def determine_location(pitcher_hand, batter_hand, balls, strikes, pitch_type)

    targets = [0.0, 0.0] # x_target, y_target

    if balls == 0 && strikes == 2 # 0-2 count
      case rand()
      when 0.0..0.25 # try to hit the edge
        targets = try_to_hit_the_edge
      when 0.25..1.0 # try to hit just off the edge
        targets = try_to_hit_just_off_the_edge
      end
    elsif balls == 1 && strikes == 2 # 1-2 count
      case rand()
      when 0.0..0.50 # try to hit the edge
        targets = try_to_hit_the_edge
      when 0.50..1.0 # try to hit just off the edge
        targets = try_to_hit_just_off_the_edge
      end
    elsif balls == 2 && strikes == 2 # 2-2 count
      case rand()
      when 0.0..0.75 # try to hit the edge
        targets = try_to_hit_the_edge
      when 0.75..1.0 # try to hit just off the edge
        targets = try_to_hit_just_off_the_edge
      end
    elsif balls == 3 # 3 balls, try to throw strike without throwing down the middle
      targets = try_to_throw_strike
    else # Less than 3 balls, try to hit the edge
      targets = try_to_hit_the_edge
    end

    modifiers = [rand()*2 - 1, rand()*2 - 1] # random values from -1 to 1

    targets[0] += 0.25 * modifiers[0]
    targets[1] += 0.25 * modifiers[1]

    if targets[0] > 1.0
      targets[0] = 0.99
    end
    if targets[1] > 1.0
      targets[1] = 0.99
    end
    if targets[0] < 0.0
      targets[0] = 0.01
    end
    if targets[1] < 0.0
      targets[1] = 0.01
    end

    coordinate_to_zone(targets)

    # zone_percentages = Array.new(72)
    # count = 1
    # sum = 0
    # # Get the pitch location percentages for each zone
    # 72.times do # count 1 to 72
    #   key = "#{count}_#{pitcher_hand}_#{batter_hand}_#{balls}_#{strikes}_#{pitch_type}"
    #   zone_percentages[count] = @heat_maps.pitch_locations[key]*location_adjustment(@pitcher, count) # adjust for pitcher control and location attributes
    #   # zone_percentages[count] = @heat_maps[:pitch_locations].where(zone_id: count, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
    #   sum += zone_percentages[count]
    #   count = count + 1
    # end
    #
    # # Calculate which zone the pitch will be in, based on the percentages
    # random_val = random_between_0_and_1 * sum
    # count = 1
    # sum = 0
    # while random_val > sum do
    #   sum += zone_percentages[count]
    #   count = count + 1
    # end
    # count - 1 # Return the correct zone
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
    when 13..18, 21, 26, 30, 35, 39, 44, 47, 52, 55..60
      true
    else
      false
    end
  end

  # Returns true if a heat map index is just off the edge of the strike zone
  def is_just_off_the_edge(index)
    case index
    when 4..11, 12, 19, 20, 27, 29, 36, 38, 45, 46, 53, 54, 61, 62..69
      true
    else
      false
    end
  end

  # Returns true if a heat map index is way off the edge of the strike zone
  def is_way_off_the_edge(index)
    case index
    when 1..3, 28, 37, 70..72
      true
    else
      false
    end
  end

  # Returns true if a heat map index is a strike but is between the edge and the middle
  def is_between_edge_and_middle(index)
    case index
    when 22..25, 31, 34, 40, 43, 48..51
      true
    else
      false
    end
  end

  # Returns true if a heat map index is in the middle of the strike zone
  def is_down_the_middle(index)
    case index
    when 32, 33, 41, 42
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
    swing_percentage = 1
    if strikes == 0 # no strikes
      if is_down_the_middle(zone_id)
        swing_percentage = 55
      elsif is_between_edge_and_middle(zone_id)
        swing_percentage = 45
      elsif is_close_to_edge(zone_id)
        swing_percentage = 35
      elsif is_just_off_the_edge(zone_id)
        swing_percentage = 25
      elsif is_way_off_the_edge(zone_id)
        swing_percentage = 10
      end
    elsif strikes == 1 # 1 strike
      if is_down_the_middle(zone_id)
        swing_percentage = 85
      elsif is_between_edge_and_middle(zone_id)
        swing_percentage = 80
      elsif is_close_to_edge(zone_id)
        swing_percentage = 65
      elsif is_just_off_the_edge(zone_id)
        swing_percentage = 50
      elsif is_way_off_the_edge(zone_id)
        swing_percentage = 15
      end
    else # 2 strikes
      if is_down_the_middle(zone_id)
        swing_percentage = 95
      elsif is_between_edge_and_middle(zone_id)
        swing_percentage = 90
      elsif is_close_to_edge(zone_id)
        swing_percentage = 80
      elsif is_just_off_the_edge(zone_id)
        swing_percentage = 60
      elsif is_way_off_the_edge(zone_id)
        swing_percentage = 25
      end
    end

    # Patient batters more likely to take pitches
    if strikes < 2
      swing_percentage *= map_attribute_to_range(@batter.patience, AttributeAdjustments::BATTER_PATIENCE_AFFECTS_SWING_PERCENTAGE_MIN, AttributeAdjustments::BATTER_PATIENCE_AFFECTS_SWING_PERCENTAGE_MAX, true)
    end

    # Batters with good plate vision less likely to swing at balls
    if !is_in_strike_zone(zone_id)
      swing_percentage *= map_attribute_to_range(@batter.plate_vision, AttributeAdjustments::BATTER_PLATE_VISION_AFFECTS_SWING_PERCENTAGE_MIN, AttributeAdjustments::BATTER_PLATE_VISION_AFFECTS_SWING_PERCENTAGE_MAX, true)
    end

    swing_percentage

    # key = "#{zone_id}_#{pitcher_hand}_#{batter_hand}_#{balls}_#{strikes}_#{pitch_type}"

    #
    # if strikes < 2
    #   @heat_maps.swing_percentages[key]*map_attribute_to_range(@batter.patience, AttributeAdjustments::BATTER_PATIENCE_AFFECTS_SWING_PERCENTAGE_MIN, AttributeAdjustments::BATTER_PATIENCE_AFFECTS_SWING_PERCENTAGE_MAX, true)*plate_vision_multiplier
    # else
    #   @heat_maps.swing_percentages[key]*plate_vision_multiplier
    # end
    # # @heat_maps[:swing_percentages].where(zone_id: zone_id, pitcher_hand: pitcher_hand, batter_hand: batter_hand, balls: balls, strikes: strikes, pitch_type: pitch_type).first.value
  end
end
