class Play
  attr_accessor :result
  def initialize(atBat)
    case atBat.result
    when AtBatResult::WALK
      puts "walk"
      @result = PlayResult::SAFE
    when AtBatResult::PUT_IN_PLAY
      puts "put in play"
      ballPutInPlay(atBat)
    when AtBatResult::STRIKEOUT
      puts "strikeout"
      @result = PlayResult::OUT
    when AtBatResult::HBP
      puts "hit by pitch"
      @result = PlayResult::SAFE
    else
      puts "this should never be reached"
    end
  end

  def ballPutInPlay(atBat)
    hit = Hit.new(atBat)
    if hit.result == HitResult::FIELDED
      @result = PlayResult::OUT
    elsif hit.result == HitResult::NOT_FIELDED
      @result = PlayResult::SAFE
    end
  end

end
