# Represents the status of an at-bat
module AtBatResult
  IN_PROGRESS = 1   # The at-bat is in progress and has not ended yet.
  WALK = 2          # The batter has walked
  PUT_IN_PLAY = 3   # The batter hit the ball in play
  STRIKEOUT = 4     # The batter has struck out
  HBP = 5           # The batter has been hit by a pitch
end

# Note that any subsequent events (whether the batter gets a hit, whether a
# fielder makes an error, what happens with the baserunners, etc) are not considered
# part of the at-bat, and therefore are not included here.
