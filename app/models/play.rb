class Play
  include Reusable
  attr_accessor :result, :hit_result, :hit
  def initialize(atBat, game)
    @game = game
    case atBat.result
    when AtBatResult::WALK
      @result = PlayResult::SAFE
    when AtBatResult::PUT_IN_PLAY
      ballPutInPlay(atBat)
    when AtBatResult::STRIKEOUT
      @result = PlayResult::OUT
    when AtBatResult::HBP
      @game.play_by_play += "\nhit by pitch\n"
      @result = PlayResult::SAFE
    else
      puts "\nthis should never be reached\n"
    end
  end

  def ballPutInPlay(atBat)
    @hit = Hit.new(atBat, @game)
    if HitResult::fielded(hit.result)
      @result = PlayResult::OUT
    else
      @result = PlayResult::SAFE
    end
    @hit_result = hit.result
  end

end
