# This class contains maximum and minimum values to be passed in to the map_attribute_to_range function
# Basically, the way this works is that each set of values represent the minimum and maximum amount
# that a calculation in the simulation is affected by a particular attribute. A value of 1.0 represents
# no change. Having all these valeus in this file makes it easy to change the effect that different
# attributes have on the simulation by making just one adjustment in one location.
class AttributeAdjustments

  #################### CONTACT PERCENTAGE ####################

  # Batter contact attribute
  BATTER_CONTACT_AFFECTS_CONTACT_PERCENTAGE_MIN = 0.8
  BATTER_CONTACT_AFFECTS_CONTACT_PERCENTAGE_MAX = 1.25

  # Pitcher arm strength attribute
  PITCHER_ARM_STRENGTH_AFFECTS_CONTACT_PERCENTAGE_MIN = 0.8
  PITCHER_ARM_STRENGTH_AFFECTS_CONTACT_PERCENTAGE_MAX = 1.25

  # Pitcher movement attribute
  PITCHER_MOVEMENT_AFFECTS_CONTACT_PERCENTAGE_MIN = 0.8
  PITCHER_MOVEMENT_AFFECTS_CONTACT_PERCENTAGE_MAX = 1.25

  #################### SWING PERCENTAGE ####################

  # Batter plate vision attribute
  BATTER_PLATE_VISION_AFFECTS_SWING_PERCENTAGE_MIN = 0.1
  BATTER_PLATE_VISION_AFFECTS_SWING_PERCENTAGE_MAX = 1.25

  # Batter patience attribute
  BATTER_PATIENCE_AFFECTS_SWING_PERCENTAGE_MIN = 0.8
  BATTER_PATIENCE_AFFECTS_SWING_PERCENTAGE_MAX = 1.25

  #################### STEAL PROBABILITY ####################

  # Runner speed attribute
  RUNNER_SPEED_AFFECTS_STEAL_PROBABILITY_MIN = 0.90
  RUNNER_SPEED_AFFECTS_STEAL_PROBABILITY_MAX = 0.999

  #################### HIT POWER ####################

  # Batter power attribute
  BATTER_POWER_AFFECTS_HIT_POWER_MIN = 10
  BATTER_POWER_AFFECTS_HIT_POWER_MAX = 80

  #################### PERCENT_FLY_BALL ####################

  # Batter uppercut attribute
  BATTER_UPPERCUT_AFFECTS_FLY_BALL_PROBABILITY_MIN = 0.3
  BATTER_UPPERCUT_AFFECTS_FLY_BALL_PROBABILITY_MAX = 0.6

  #################### PERCENT_LINE_DRIVE ####################

  # Batter batting average attribute
  BATTER_BATTING_AVERAGE_AFFECTS_LINE_DRIVE_PROBABILITY_MIN = 0.30
  BATTER_BATTING_AVERAGE_AFFECTS_LINE_DRIVE_PROBABILITY_MAX = 0.45

  #################### PERCENT_POP_UP ####################

  # Batter batting average attribute
  BATTER_BATTING_AVERAGE_AFFECTS_POP_UP_PROBABILITY_MIN = 0.05
  BATTER_BATTING_AVERAGE_AFFECTS_POP_UP_PROBABILITY_MAX = 0.15

  #################### PULL AMOUNT ####################

  # Batter pull amount attribute
  BATTER_PULL_AMOUNT_AFFECTS_PULL_PROBABILITY_MIN = 0.25
  BATTER_PULL_AMOUNT_AFFECTS_PULL_PROBABILITY_MAX = 0.50

  #################### CHANCE OF DEFENDER REACHING BALL ####################

  # Batter batting average attribute
  BATTER_BATTING_AVERAGE_AFFECTS_FIELD_PROBABILITY_MIN = 0.85
  BATTER_BATTING_AVERAGE_AFFECTS_FIELD_PROBABILITY_MAX = 1.15


end
