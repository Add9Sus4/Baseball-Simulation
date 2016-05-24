class Hit
  attr_accessor :result, :type, :location
  def initialize(atbat)
    @atbat = atbat
    hitType
    hitLocation
    hitResult
  end

  # What kind of hit was it?
  def hitType
    @type = HitType::GROUND_BALL
  end

  # Where was the ball hit?
  def hitLocation
    @location = HitLocation::SHORTSTOP
  end

  # How likely is it that the fielder will reach the ball?
  def chanceOfReachingBall
    0.90
  end

  # Result of the play
  def hitResult
    if rand() < chanceOfReachingBall
      @result = HitResult::FIELDED
    else
      @result = HitResult::NOT_FIELDED
    end
    puts "#{@type} hit to #{@location}, #{@result}"
  end

end
