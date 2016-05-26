class Hit
  attr_accessor :result, :type, :location
  def initialize(atbat, game)
    @game = game
    @atbat = atbat
    hitType
    hitLocation
    hitResult
  end

  # What kind of hit was it?
  def hitType
    random = rand()
    if random < 0.25
      @type = HitType::GROUND_BALL
    elsif random < 0.5
      @type = HitType::LINE_DRIVE
    elsif random < 0.75
      @type = HitType::FLY_BALL
    else
      @type = HitType::POP_UP
    end
  end

  # Where was the ball hit?
  def hitLocation
    random = rand()
    if random < 0.11
      @location = HitLocation::CATCHER
    elsif random < 0.22
      @location = HitLocation::PITCHER
    elsif random < 0.33
      @location = HitLocation::FIRST_BASEMAN
    elsif random < 0.44
      @location = HitLocation::SECOND_BASEMAN
    elsif random < 0.55
      @location = HitLocation::THIRD_BASEMAN
    elsif random < 0.66
      @location = HitLocation::SHORTSTOP
    elsif random < 0.77
      @location = HitLocation::LEFT_FIELDER
    elsif random < 0.88
      @location = HitLocation::CENTER_FIELDER
    else
      @location = HitLocation::RIGHT_FIELDER
    end
  end

  # How likely is it that the fielder will reach the ball?
  def chanceOfReachingBall
    0.70
  end

  # Result of the play
  def hitResult
    if rand() < chanceOfReachingBall
      @result = HitResult::FIELDED
    else
      random = rand()
      if random < 0.50
        @result = HitResult::SINGLE
      elsif random < 0.80
        @result = HitResult::DOUBLE
      elsif random < 0.95
        @result = HitResult::HOME_RUN
      else
        @result = HitResult::TRIPLE
      end
    end
    if @result == HitResult::FIELDED
      @game.pbp += "\n<span style=\"color:" + @game.bad + "\">#{@atbat.batter.full_name} hits a #{@type} to #{@location}, #{@result}</span>\n"
    else
      @game.pbp += "\n<span style=\"color:" + @game.good + "\">#{@atbat.batter.full_name} hits a #{@type} to #{@location}, #{@result}</span>\n"
    end

  end

end
