# These are the different types of pitches that can be thrown.
# Each pitch is affected differently by the different pitcher
# attributes. This is done by assigning a "weight" to each
# attribute, and the sum of all weights always equals 1.
module PitchType
  FOUR_SEAM_FASTBALL  = 1 # 90% arm strength, 10% movement
  TWO_SEAM_FASTBALL   = 2 # 70% arm strength, 30% movement
  CUTTER              = 3 # 65% arm strength, 35% movement
  SPLITTER            = 4 # 50% arm strength, 50% movement
  FORKBALL            = 5 # 35% arm strength, 65% movement
  SINKER              = 6 # 45% arm strength, 55% movement
  SLIDER              = 7 # 55% arm strength, 45% movement
  CURVEBALL           = 8 # 10% arm strength, 90% movement
  KNUCKLE_CURVE       = 9 # 5% arm strength, 95% movement
  EEPHUS              = 10 # 0% arm strength, 100% movement
  CHANGEUP            = 11 # 0% arm strength, 100% movement
  SCREWBALL           = 12 # 60% arm strength, 40% movement
  KNUCKLEBALL         = 13 # 5% arm strength, 95% movement
  MYSTERY_PITCH       = 14 # generated randomly every time
end
