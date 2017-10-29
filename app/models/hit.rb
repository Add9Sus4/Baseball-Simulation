class Hit
  include Reusable
  attr_accessor :result, :type, :location, :power, :play_by_play, :fielder
  def initialize(atbat)
    @play_by_play = ""
    @atbat = atbat
    hitPower
    hitType
    hitLocation
    hitResult
    @fielder = nil
  end

  def hitPower
    # Batter power affects hit power
    average_power = map_attribute_to_range(@atbat.batter.power, AttributeAdjustments::BATTER_POWER_AFFECTS_HIT_POWER_MIN, AttributeAdjustments::BATTER_POWER_AFFECTS_HIT_POWER_MAX, false)

    # Batter contact slightly affects hit power (contact of 0 -> no change, contact of 100 -> 5% reduction in power)
    contact_adjustment = map_attribute_to_range(@atbat.batter.contact, AttributeAdjustments::BATTER_CONTACT_AFFECTS_HIT_POWER_MIN, AttributeAdjustments::BATTER_CONTACT_AFFECTS_HIT_POWER_MAX, true)

    @power = getRandomValue(0, 1, 0, 100, average_power, 20)*contact_adjustment
  end

  # What kind of hit was it?
  def hitType

    # Adjustment for uppercut amount
    percent_in_the_air = map_attribute_to_range(@atbat.batter.uppercut_amount, AttributeAdjustments::BATTER_UPPERCUT_AFFECTS_FLY_BALL_PROBABILITY_MIN, AttributeAdjustments::BATTER_UPPERCUT_AFFECTS_FLY_BALL_PROBABILITY_MAX, false)

    percent_not_in_the_air = 1.0 - percent_in_the_air

    # Percent of balls not in the air that are line drives (Batting average adjustment)
    percent_line_drives = percent_not_in_the_air * map_attribute_to_range(@atbat.batter.batting_average, AttributeAdjustments::BATTER_BATTING_AVERAGE_AFFECTS_LINE_DRIVE_PROBABILITY_MIN, AttributeAdjustments::BATTER_BATTING_AVERAGE_AFFECTS_LINE_DRIVE_PROBABILITY_MAX, false)

    # Percent of balls in the air that are pop ups (Batting average adjustment)
    percent_pop_ups = map_attribute_to_range(@atbat.batter.batting_average, AttributeAdjustments::BATTER_BATTING_AVERAGE_AFFECTS_POP_UP_PROBABILITY_MIN, AttributeAdjustments::BATTER_BATTING_AVERAGE_AFFECTS_POP_UP_PROBABILITY_MAX, true)

    percent_fly_balls = percent_in_the_air - percent_pop_ups

    percent_grounders = percent_not_in_the_air - percent_line_drives

    random = rand()
    if random < percent_grounders
      @type = HitType::GROUND_BALL
    elsif random < percent_grounders + percent_line_drives
      @type = HitType::LINE_DRIVE
    elsif random < percent_grounders + percent_line_drives + percent_fly_balls
      @type = HitType::FLY_BALL
    else
      @type = HitType::POP_UP
    end
  end

  # Where was the ball hit?
  def hitLocation

    # Adjustment for pull amount
    percent_pulled = map_attribute_to_range(@atbat.batter.pull_amount, AttributeAdjustments::BATTER_PULL_AMOUNT_AFFECTS_PULL_PROBABILITY_MIN, AttributeAdjustments::BATTER_PULL_AMOUNT_AFFECTS_PULL_PROBABILITY_MAX, false)

    percent_oppo = 1.0 - percent_pulled

    percent_left = 0
    percent_right = 0

    if @atbat.batter.hitting_side == "RIGHT"
      percent_left = percent_pulled
      percent_right = 1.0 - percent_left
    else
      percent_right = percent_pulled
      percent_left = 1.0 - percent_right
    end

    left = true

    if rand() > percent_left
      left = false
    end

    case @type
    when HitType::GROUND_BALL

      # Weak grounder
      if rand() > 0.80
        if rand() > 0.50
          @location = HitLocation::CATCHER
        else
          @location = HitLocation::PITCHER
        end
        # Not weak grounder
      else
        if left
          if rand() > 0.35
            @location = HitLocation::SHORTSTOP
          else
            @location = HitLocation::THIRD_BASEMAN
          end
        else
          if rand() > 0.35
            @location = HitLocation::SECOND_BASEMAN
          else
            @location = HitLocation::FIRST_BASEMAN
          end
        end
      end
    when HitType::LINE_DRIVE
      if left
        if rand() < 0.05
          @location = HitLocation::PITCHER
        elsif rand() < 0.35
          @location = HitLocation::THIRD_BASEMAN
        else
          @location = HitLocation::SHORTSTOP
        end
      else
        if rand() < 0.05
          @location = HitLocation::PITCHER
        elsif rand() < 0.35
          @location = HitLocation::FIRST_BASEMAN
        else
          @location = HitLocation::SECOND_BASEMAN
        end
      end
    when HitType::FLY_BALL
      if left
        if rand() > 0.40
          @location = HitLocation::LEFT_FIELDER
        else
          @location = HitLocation::CENTER_FIELDER
        end
      else
        if rand() > 0.40
          @location = HitLocation::RIGHT_FIELDER
        else
          @location = HitLocation::CENTER_FIELDER
        end
      end
    when HitType::POP_UP
      # pitcher or catcher
      if rand() < 0.10
        if rand() > 0.50
          @location = HitLocation::CATCHER
        else
          @location = HitLocation::PITCHER
        end
        # other positions
      else
        if left
          if rand() < 0.35
            @location = HitLocation::THIRD_BASEMAN
          else
            @location = HitLocation::SHORTSTOP
          end
        else
          if rand() < 0.35
            @location = HitLocation::FIRST_BASEMAN
          else
            @location = HitLocation::SECOND_BASEMAN
          end
        end
      end
    end
  end

  # How likely is it that the fielder will reach the ball?
  def chanceOfReachingBall
    location_factor = 1
    case @type
    when HitType::GROUND_BALL
      location_factor = 0.80
    when HitType::LINE_DRIVE
      location_factor = 0.70
    when HitType::FLY_BALL
      location_factor = 0.80
    when HitType::POP_UP
      location_factor = 0.98
    end
    0.90*location_factor*map_attribute_to_range(@atbat.batter.batting_average, AttributeAdjustments::BATTER_BATTING_AVERAGE_AFFECTS_FIELD_PROBABILITY_MIN, AttributeAdjustments::BATTER_BATTING_AVERAGE_AFFECTS_FIELD_PROBABILITY_MAX, true)
  end

  # Result of the play
  def hitResult

    case @location
    when HitLocation::PITCHER
      case @type
      when HitType::GROUND_BALL
        if rand() < chanceOfReachingBall
           hits_grounder("PITCHER")
        else
          hits_single("PITCHER")
        end
      when HitType::LINE_DRIVE
        if rand() < chanceOfReachingBall
          hits_liner("PITCHER")
        else
          hits_single("CENTER")
        end
      when HitType::POP_UP
        if rand() < chanceOfReachingBall
          hits_popup("PITCHER")
        else
          hits_single("PITCHER")
        end
      end
    when HitLocation::CATCHER
      case @type
      when HitType::GROUND_BALL
        if rand() < chanceOfReachingBall
          hits_grounder("CATCHER")
        else
          hits_single("CATCHER")
        end
      when HitType::POP_UP
        if rand() < chanceOfReachingBall
          hits_popup("CATCHER")
        else
          hits_single("CATCHER")
        end
      end
    when HitLocation::FIRST_BASEMAN
      case @type
      when HitType::GROUND_BALL
        if rand() < chanceOfReachingBall
          hits_grounder("FIRST")
        else
          if rand() > Constants::PERCENT_SINGLES_TO_EXTRA_BASE_HITS
            hits_single("RIGHT")
          else
            hits_double("RIGHT")
          end
        end
      when HitType::LINE_DRIVE
        if rand() < chanceOfReachingBall
          hits_liner("FIRST")
        else
          random = rand()
          if random > Constants::PERCENT_SINGLES_TO_EXTRA_BASE_HITS
            hits_single("RIGHT")
          elsif random < Constants::PERCENT_DOUBLES_TO_TRIPLES
            hits_double("RIGHT")
          else
            hits_triple("RIGHT")
          end
        end
      when HitType::POP_UP
        if rand() < chanceOfReachingBall
          hits_popup("FIRST")
        else
          hits_single("FIRST")
        end
      end
    when HitLocation::SECOND_BASEMAN
      case @type
      when HitType::GROUND_BALL
        if rand() < chanceOfReachingBall
          hits_grounder("SECOND")
        else
          if rand() > 0.75
            hits_single("RIGHT")
          else
            hits_single("CENTER")
          end
        end
      when HitType::LINE_DRIVE
        if rand() < chanceOfReachingBall
          hits_liner("SECOND")
        else
          random = rand()
          if random < 0.50
            if rand() > 0.75
              hits_single("RIGHT")
            else
              hits_single("CENTER")
            end
          else
            if rand() < Constants::PERCENT_DOUBLES_TO_TRIPLES
              hits_double("RIGHT_CENTER")
            else
              if rand() > 0.50
                hits_triple("RIGHT")
              else
                hits_triple("CENTER")
              end
            end
          end
        end
      when HitType::POP_UP
        if rand() < chanceOfReachingBall
          hits_popup("SECOND")
        else
          hits_single("SECOND")
        end
      end
    when HitLocation::THIRD_BASEMAN
      case @type
      when HitType::GROUND_BALL
        if rand() < chanceOfReachingBall
          hits_grounder("THIRD")
        else
          if rand() > Constants::PERCENT_SINGLES_TO_EXTRA_BASE_HITS
            hits_single("LEFT")
          else
            hits_double("LEFT")
          end
        end
      when HitType::LINE_DRIVE
        if rand() < chanceOfReachingBall
          hits_liner("THIRD")
        else
          random = rand()
          if random > Constants::PERCENT_SINGLES_TO_EXTRA_BASE_HITS
            hits_single("LEFT")
          elsif random < Constants::PERCENT_DOUBLES_TO_TRIPLES
            hits_double("LEFT")
          else
            hits_triple("LEFT")
          end
        end
      when HitType::POP_UP
        if rand() < chanceOfReachingBall
          hits_popup("THIRD")
        else
          hits_single("THIRD")
        end
      end
    when HitLocation::SHORTSTOP
      case @type
      when HitType::GROUND_BALL
        if rand() < chanceOfReachingBall
          hits_grounder("SHORT")
        else
          if rand() > 0.75
            hits_single("LEFT")
          else
            hits_single("CENTER")
          end
        end
      when HitType::LINE_DRIVE
        if rand() < chanceOfReachingBall
          hits_liner("SHORT")
        else
          random = rand()
          if random < 0.50
            if rand() > 0.75
              hits_single("LEFT")
            else
              hits_single("CENTER")
            end
          else
            if rand() < Constants::PERCENT_DOUBLES_TO_TRIPLES
              hits_double("LEFT_CENTER")
            else
              if rand() > 0.50
                hits_triple("LEFT")
              else
                hits_triple("CENTER")
              end
            end
          end
        end
      when HitType::POP_UP
        if rand() < chanceOfReachingBall
          hits_popup("SHORT")
        else
          hits_single("SHORT")
        end
      end
    when HitLocation::LEFT_FIELDER
      if rand() < chanceOfReachingBall
        hits_fly_ball("LEFT")
      elsif rand(60..100) < @power
        hits_home_run("LEFT")
      elsif rand() < 0.50 # Single instead of double or triple
        hits_single("LEFT")
      else
        if rand() < Constants::PERCENT_DOUBLES_TO_TRIPLES
          if rand() < 0.50
            hits_double("LEFT")
          else
            hits_double("LEFT_CENTER")
          end
        else
          hits_triple("LEFT")
        end
      end
    when HitLocation::CENTER_FIELDER
      if rand() < chanceOfReachingBall
        hits_fly_ball("CENTER")
      elsif rand(0..100) < @power
        hits_home_run("CENTER")
      elsif rand() < 0.50 # Single instead of double or triple
        hits_single("CENTER")
      else
        if rand() < Constants::PERCENT_DOUBLES_TO_TRIPLES
          if rand() < 0.50
            hits_double("LEFT_CENTER")
          else
            hits_double("RIGHT_CENTER")
          end
        else
          hits_triple("CENTER")
        end
      end
    when HitLocation::RIGHT_FIELDER
      if rand() < chanceOfReachingBall
        hits_fly_ball("RIGHT")
      elsif rand(0..100) < @power
        hits_home_run("RIGHT")
      elsif rand() < 0.50 # Single instead of double or triple
        hits_single("RIGHT")
      else
        if rand() < Constants::PERCENT_DOUBLES_TO_TRIPLES
          if rand() < 0.50
            hits_double("RIGHT")
          else
            hits_double("RIGHT_CENTER")
          end
        else
          hits_triple("RIGHT")
        end
      end
    end

    if HitResult.fielded(@result)
      @play_by_play += "\n<span style=\"color:" + color_bad + "\">#{@atbat.batter.full_name} hits a #{@result}, fielded by #{@fielder}</span>\n"
    else
      @play_by_play += "\n<span style=\"color:" + color_good + "\">#{@atbat.batter.full_name} hits a #{@result}</span>\n"
    end
  end

  def hits_single(location)
    case location
    when "LEFT"
      @result = HitResult::SINGLE_TO_LEFT
    when "CENTER"
      @result = HitResult::SINGLE_TO_CENTER
    when "RIGHT"
      @result = HitResult::SINGLE_TO_RIGHT
    when "PITCHER"
      @result = HitResult::INFIELD_SINGLE_TO_PITCHER
    when "CATCHER"
      @result = HitResult::INFIELD_SINGLE_TO_CATCHER
    when "FIRST"
      @result = HitResult::INFIELD_SINGLE_TO_FIRST
    when "SECOND"
      @result = HitResult::INFIELD_SINGLE_TO_SECOND
    when "SHORT"
      @result = HitResult::INFIELD_SINGLE_TO_SHORT
    when "THIRD"
      @result = HitResult::INFIELD_SINGLE_TO_THIRD
    end
  end

  def hits_double(location)
    case location
    when "LEFT"
      @result = HitResult::DOUBLE_TO_LEFT
    when "LEFT_CENTER"
      @result = HitResult::DOUBLE_TO_LEFT_CENTER
    when "RIGHT_CENTER"
      @result = HitResult::DOUBLE_TO_RIGHT_CENTER
    when "RIGHT"
      @result = HitResult::DOUBLE_TO_RIGHT
    end
  end

  def hits_triple(location)
    case location
    when "LEFT"
      @result = HitResult::TRIPLE_TO_LEFT
    when "CENTER"
      @result = HitResult::TRIPLE_TO_CENTER
    when "RIGHT"
      @result = HitResult::TRIPLE_TO_RIGHT
    end
  end

  def get_fielder(position_abbrev)
    @atbat.fielding_team.game_position_players[position_abbrev]
  end

  def hits_fly_ball(location)
    case location
    when "LEFT"
      @result = HitResult::FLY_BALL_TO_LEFT
      @fielder = get_fielder("LF")
      @fielder.records_putout
    when "CENTER"
      @result = HitResult::FLY_BALL_TO_CENTER
      @fielder = get_fielder("CF")
      @fielder.records_putout
    when "RIGHT"
      @result = HitResult::FLY_BALL_TO_RIGHT
      @fielder = get_fielder("RF")
      @fielder.records_putout
    end
  end

  def hits_home_run(location)
    case location
    when "LEFT"
      @result = HitResult::HOME_RUN_TO_LEFT
    when "CENTER"
      @result = HitResult::HOME_RUN_TO_CENTER
    when "RIGHT"
      @result = HitResult::HOME_RUN_TO_RIGHT
    end
  end

  def hits_grounder(location)
    case location
    when "THIRD"
      @result = HitResult::GROUNDER_TO_THIRD
      @fielder = get_fielder("3B")
      @fielder.records_assist
    when "SHORT"
      @result = HitResult::GROUNDER_TO_SHORT
      @fielder = get_fielder("SS")
      @fielder.records_assist
    when "SECOND"
      @result = HitResult::GROUNDER_TO_SECOND
      @fielder = get_fielder("2B")
      @fielder.records_assist
    when "FIRST"
      @result = HitResult::GROUNDER_TO_FIRST
      @fielder = get_fielder("1B")
      @fielder.records_assist
    when "PITCHER"
      @result = HitResult::GROUNDER_TO_PITCHER
      @fielder = @atbat.pitcher
      @fielder.records_assist
    when "CATCHER"
      @result = HitResult::GROUNDER_TO_CATCHER
      @fielder = get_fielder("C")
      @fielder.records_assist
    end
  end

  def hits_liner(location)
    case location
    when "THIRD"
      @result = HitResult::LINER_TO_THIRD
      @fielder = get_fielder("3B")
      @fielder.records_putout
    when "SHORT"
      @result = HitResult::LINER_TO_SHORT
      @fielder = get_fielder("SS")
      @fielder.records_putout
    when "SECOND"
      @result = HitResult::LINER_TO_SECOND
      @fielder = get_fielder("2B")
      @fielder.records_putout
    when "FIRST"
      @result = HitResult::LINER_TO_FIRST
      @fielder = get_fielder("1B")
      @fielder.records_putout
    when "PITCHER"
      @result = HitResult::LINER_TO_PITCHER
      @fielder = @atbat.pitcher
      @fielder.records_putout
    when "CATCHER"
      @result = HitResult::LINER_TO_CATCHER #TODO: make sure this never happens
      @fielder = get_fielder("C")
      @fielder.records_putout
    end
  end

  def hits_popup(location)
    case location
    when "THIRD"
      @result = HitResult::POPUP_TO_THIRD
      @fielder = get_fielder("3B")
      @fielder.records_putout
    when "SHORT"
      @result = HitResult::POPUP_TO_SHORT
      @fielder = get_fielder("SS")
      @fielder.records_putout
    when "SECOND"
      @result = HitResult::POPUP_TO_SECOND
      @fielder = get_fielder("2B")
      @fielder.records_putout
    when "FIRST"
      @result = HitResult::POPUP_TO_FIRST
      @fielder = get_fielder("1B")
      @fielder.records_putout
    when "PITCHER"
      @result = HitResult::POPUP_TO_PITCHER
      @fielder = @atbat.pitcher
      @fielder.records_putout
    when "CATCHER"
      @result = HitResult::POPUP_TO_CATCHER
      @fielder = get_fielder("C")
      @fielder.records_putout
    end
  end

end
