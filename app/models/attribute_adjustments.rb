# This class contains maximum and minimum values to be passed in to the map_attribute_to_range function
# Basically, the way this works is that each set of values represent the minimum and maximum amount
# that a calculation in the simulation is affected by a particular attribute. A value of 1.0 represents
# no change. Having all these values in this file makes it easy to change the effect that different
# attributes have on the simulation by making just one adjustment in one location.
class AttributeAdjustments

  #################### CONTACT PERCENTAGE ####################

  # Batter contact attribute
  BATTER_CONTACT_AFFECTS_CONTACT_PERCENTAGE_MIN = 0.8   # 0 contact   -> 20% decrease in contact %
  BATTER_CONTACT_AFFECTS_CONTACT_PERCENTAGE_MAX = 1.25  # 100 contact -> 25% increase in contact %

  # Pitcher arm strength attribute (inverse)
  PITCHER_ARM_STRENGTH_AFFECTS_CONTACT_PERCENTAGE_MIN = 0.8   # 100 arm strength  -> 30% decrease in contact %
  PITCHER_ARM_STRENGTH_AFFECTS_CONTACT_PERCENTAGE_MAX = 1.25  # 0 arm strength    -> 30% increase in contact %

  # Pitcher movement attribute (inverse)
  PITCHER_MOVEMENT_AFFECTS_CONTACT_PERCENTAGE_MIN = 0.8   # 100 movement  -> 70% decrease in contact %
  PITCHER_MOVEMENT_AFFECTS_CONTACT_PERCENTAGE_MAX = 1.25  # 0 movement    -> 30% increase in contact %

  #################### SWING PERCENTAGE ####################

  # Batter plate vision attribute (inverse)
  BATTER_PLATE_VISION_AFFECTS_SWING_PERCENTAGE_MIN = 0.65  # 100 plate vision  -> 35% decrease in swing % on pitches out of the zone
  BATTER_PLATE_VISION_AFFECTS_SWING_PERCENTAGE_MAX = 1.25 # 0 plate vision    -> 25% increase in swing % on pitches out of the zone

  # Batter patience attribute when ahead in count (inverse)
  BATTER_PATIENCE_AFFECTS_SWING_PERCENTAGE_WHEN_AHEAD_IN_COUNT_MIN = 0.7  # 100 patience  -> 30% decrease in overall swing %
  BATTER_PATIENCE_AFFECTS_SWING_PERCENTAGE_WHEN_AHEAD_IN_COUNT_MAX = 1.5  # 0 patience    -> 50% increase in overall swing %

  # Batter patience attribute when count is even (inverse)
  BATTER_PATIENCE_AFFECTS_SWING_PERCENTAGE_WHEN_COUNT_IS_EVEN_MIN = 0.8   # 100 patience  -> 20% decrease in overall swing %
  BATTER_PATIENCE_AFFECTS_SWING_PERCENTAGE_WHEN_COUNT_IS_EVEN_MAX = 1.25  # 0 patience    -> 25% increase in overall swing %

  #################### STEAL PROBABILITY ####################

  # Runner speed attribute (inverse)
  RUNNER_SPEED_AFFECTS_STEAL_PROBABILITY_MIN = 0.90   # 100 speed -> 10% chance of stealing on a given opportunity
  RUNNER_SPEED_AFFECTS_STEAL_PROBABILITY_MAX = 0.999  # 1 speed   -> 0.1% chance of stealing on a given opportunity

  #################### HIT POWER ####################

  # Batter power attribute
  BATTER_POWER_AFFECTS_HIT_POWER_MIN = 10 # 0 power   -> hit power is generated from a distribution centered around a mean of 10
  BATTER_POWER_AFFECTS_HIT_POWER_MAX = 80 # 100 power -> hit power is generated from a distribution centered around a mean of 80

  # Batter contact attribute
  BATTER_CONTACT_AFFECTS_HIT_POWER_MIN = 0.95 # 100 contact -> 5% decrease in hit power
  BATTER_CONTACT_AFFECTS_HIT_POWER_MAX = 1.0  # 0 contact   -> no change

  #################### PERCENT_FLY_BALL ####################

  # Batter uppercut attribute
  BATTER_UPPERCUT_AFFECTS_FLY_BALL_PROBABILITY_MIN = 0.3 # 0 uppercut   -> 30% fly balls
  BATTER_UPPERCUT_AFFECTS_FLY_BALL_PROBABILITY_MAX = 0.6 # 100 uppercut -> 60% fly balls

  # Batter contact attribute
  BATTER_CONTACT_AFFECTS_FLY_BALL_PROBABILITY_MIN = 0.8 # 100 contact -> 20% decrease in fly balls
  BATTER_CONTACT_AFFECTS_FLY_BALL_PROBABILITY_MAX = 1.0 # 0 contact   -> no change

  #################### PERCENT_LINE_DRIVE ####################

  # Batter batting average attribute
  BATTER_BATTING_AVERAGE_AFFECTS_LINE_DRIVE_PROBABILITY_MIN = 0.30  # 0 batting average   -> 30% of all non-fly balls are line drives
  BATTER_BATTING_AVERAGE_AFFECTS_LINE_DRIVE_PROBABILITY_MAX = 0.45  # 100 batting average -> 45% of all non-fly balls are line drives

  #################### PERCENT_POP_UP ####################

  # Batter batting average attribute (inverse)
  BATTER_BATTING_AVERAGE_AFFECTS_POP_UP_PROBABILITY_MIN = 0.05  # 100 batting average -> 5% of all fly balls are pop-ups
  BATTER_BATTING_AVERAGE_AFFECTS_POP_UP_PROBABILITY_MAX = 0.15  # 0 batting average   -> 15% of all fly balls are pop-ups

  #################### PULL AMOUNT ####################

  # Batter pull amount attribute
  BATTER_PULL_AMOUNT_AFFECTS_PULL_PROBABILITY_MIN = 0.25  # 0 pull amount   -> 25% of all hits are pulled
  BATTER_PULL_AMOUNT_AFFECTS_PULL_PROBABILITY_MAX = 0.50  # 100 pull amount -> 50% of all hits are pulled

  #################### CHANCE OF DEFENDER REACHING BALL ####################

  # Batter batting average attribute (inverse)
  BATTER_BATTING_AVERAGE_AFFECTS_FIELD_PROBABILITY_MIN = 0.85 # 100 batting average -> 15% increase in hit probability
  BATTER_BATTING_AVERAGE_AFFECTS_FIELD_PROBABILITY_MAX = 1.08 # 0 batting average   -> 8% decrease in hit probability

  # Reaction time
  FIELDER_REACTION_TIME_AFFECTS_FIELD_PROBABILITY_MIN = 0.85 # 0 reaction time -> 15% increase in hit probability
  FIELDER_REACTION_TIME_AFFECTS_FIELD_PROBABILITY_MAX = 1.15 # 100 reaction time -> 15% decrease in hit probability

  # Agility
  FIELDER_AGILITY_AFFECTS_FIELD_PROBABILITY_MIN = 0.85 # 0 agility -> 15% increase in hit probability
  FIELDER_AGILITY_AFFECTS_FIELD_PROBABILITY_MAX = 1.15 # 100 agility -> 15% decrease in hit probability

  # Speed
  FIELDER_SPEED_AFFECTS_FIELD_PROBABILITY_MIN = 0.85 # 0 speed -> 15% increase in hit probability
  FIELDER_SPEED_AFFECTS_FIELD_PROBABILITY_MAX = 1.15 # 100 speed -> 15% decrease in hit probability

  #################### THROWING BALLS AND STRIKES ####################

  # Pitching control (inverse)
  PITCHER_CONTROL_AFFECTS_PROBABILITY_OF_TRYING_TO_THROW_BALL_MIN = 0.01  # 100 control -> 1% of the time, pitcher will try to throw "just off the edge" no matter the situation
  PITCHER_CONTROL_AFFECTS_PROBABILITY_OF_TRYING_TO_THROW_BALL_MAX = 0.50  # 0 control -> 50% of the time, pitcher will try to throw "just off the edge" no matter the situation

  # Pitching control
  PITCHER_CONTROL_AFFECTS_PROBABILITY_OF_TRYING_TO_THROW_STRIKE_MIN = 0.01  # 0 control -> 1% of the time, pitcher will try to throw a strike near the middle of the zone (but not down the middle) no matter the situation
  PITCHER_CONTROL_AFFECTS_PROBABILITY_OF_TRYING_TO_THROW_STRIKE_MAX = 0.50  # 100 control -> 50% of the time, pitcher will try to throw a strike near the middle of the zone (but not down the middle) no matter the situation

  #################### PITCHER ACCURACY ####################

  # Pitching location (inverse)
  PITCHER_LOCATION_AFFECTS_TARGET_VARIATION_MIN = 0.15 # 100 location -> targets are off by a maximum of +/- 0.15
  PITCHER_LOCATION_AFFECTS_TARGET_VARIATION_MAX = 0.35 # 0 location -> targets are off by a maximum of +/- 0.35

  #################### ENDURANCE ####################

  # Pitcher energy losses (inverse)
  PITCHER_ENDURANCE_AFFECTS_ENERGY_LOSS_PER_PITCH_MIN = 0.75  # 100 endurance -> lose 0.75% energy each pitch
  PITCHER_ENDURANCE_AFFECTS_ENERGY_LOSS_PER_PITCH_MAX = 3     # 0 endurance -> lose 3% energy each pitch

  #################### ENDURANCE ####################

  # Pitcher arm strength losses
  PITCHER_ENDURANCE_AFFECTS_ARM_STRENGTH_MIN = 0.70 # 0 endurance -> lose 30% of arm strength attribute
  PITCHER_ENDURANCE_AFFECTS_ARM_STRENGTH_MAX = 1.0 # 100 endurance -> lose 0% of arm strength attribute

  # Pitcher location losses
  PITCHER_ENDURANCE_AFFECTS_LOCATION_MIN = 0.80 # 0 endurance -> lose 20% of location attribute
  PITCHER_ENDURANCE_AFFECTS_LOCATION_MAX = 1.0 # 100 endurance -> lose 0% of location attribute

  # Pitcher control losses
  PITCHER_ENDURANCE_AFFECTS_CONTROL_MIN = 0.80 # 0 endurance -> lose 20% of control attribute
  PITCHER_ENDURANCE_AFFECTS_CONTROL_MAX = 1.0 # 100 endurance -> lose 0% of control attribute

  #################### INTELLIGENCE ####################

  # Attribute improvement
  PLAYER_INTELLIGENCE_AFFECTS_ATTRIBUTE_IMPROVEMENT_MIN = 5   # 0 intelligence -> gain at most 5 pts each season
  PLAYER_INTELLIGENCE_AFFECTS_ATTRIBUTE_IMPROVEMENT_MAX = 25  # 100 intelligence -> gain at most 25 pts each season

  # Attribute decline (inverse)
  PLAYER_INTELLIGENCE_AFFECTS_ATTRIBUTE_DECLINE_MIN = 5   # 100 intelligence -> lose at most 5 pts each season
  PLAYER_INTELLIGENCE_AFFECTS_ATTRIBUTE_DECLINE_MAX = 25  # 0 intelligence -> lose at most 25 pts each season
end
