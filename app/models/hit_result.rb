module HitResult

  POPUP_TO_PITCHER = "pop up to the pitcher"
  POPUP_TO_CATCHER = "pop up to the catcher"
  POPUP_TO_FIRST = "pop up to first"
  POPUP_TO_SECOND = "pop up to second"
  POPUP_TO_SHORT = "pop up to short"
  POPUP_TO_THIRD = "pop up to third"

  GROUNDER_TO_PITCHER = "grounder to the pitcher"
  GROUNDER_TO_CATCHER = "grounder to the catcher"
  GROUNDER_TO_FIRST = "grounder to first"
  GROUNDER_TO_SECOND = "grounder to second"
  GROUNDER_TO_SHORT = "grounder to short"
  GROUNDER_TO_THIRD = "grounder to third"

  LINER_TO_PITCHER = "liner to the pitcher"
  LINER_TO_FIRST = "liner to first"
  LINER_TO_SECOND = "liner to second"
  LINER_TO_SHORT = "liner to short"
  LINER_TO_THIRD = "liner to third"

  FLY_BALL_TO_LEFT = "fly ball to left"
  FLY_BALL_TO_CENTER = "fly ball to center"
  FLY_BALL_TO_RIGHT = "fly ball to right"

  INFIELD_SINGLE_TO_PITCHER = "infield single to the pitcher"
  INFIELD_SINGLE_TO_CATCHER = "infield single to the catcher"
  INFIELD_SINGLE_TO_FIRST = "infield single to first"
  INFIELD_SINGLE_TO_SECOND = "infield single to second"
  INFIELD_SINGLE_TO_THIRD = "infield single to third"
  INFIELD_SINGLE_TO_SHORT = "infield single to short"
  SINGLE_TO_CENTER = "single to center"
  SINGLE_TO_LEFT = "single to left"
  SINGLE_TO_RIGHT = "single to right"
  DOUBLE_TO_LEFT = "double down the left field line"
  DOUBLE_TO_LEFT_CENTER = "double in the left center gap"
  DOUBLE_TO_RIGHT_CENTER = "double in the right center gap"
  DOUBLE_TO_RIGHT = "double down the right field line"
  TRIPLE_TO_LEFT = "triple to left"
  TRIPLE_TO_RIGHT = "triple to right"
  TRIPLE_TO_CENTER = "triple to center"
  HOME_RUN_TO_LEFT = "home run to deep left"
  HOME_RUN_TO_CENTER = "home run to deep center"
  HOME_RUN_TO_RIGHT = "home run to deep right"

  def self.is_infield_single(result)
    case result
    when INFIELD_SINGLE_TO_SHORT, INFIELD_SINGLE_TO_THIRD, INFIELD_SINGLE_TO_SECOND,
      INFIELD_SINGLE_TO_FIRST, INFIELD_SINGLE_TO_CATCHER, INFIELD_SINGLE_TO_PITCHER
      true
    else
      false
    end
  end

  def self.is_a_home_run(result)
    case result
    when HOME_RUN_TO_RIGHT, HOME_RUN_TO_LEFT, HOME_RUN_TO_CENTER
      true
    else
      false
    end
  end

  def self.is_a_triple(result)
    case result
    when TRIPLE_TO_LEFT, TRIPLE_TO_RIGHT, TRIPLE_TO_CENTER
      true
    else
      false
    end
  end

  def self.is_a_double(result)
    case result
    when DOUBLE_TO_LEFT, DOUBLE_TO_RIGHT, DOUBLE_TO_RIGHT_CENTER, DOUBLE_TO_LEFT_CENTER
      true
    else
      false
    end
  end

  def self.is_a_single(result)
    case result
    when SINGLE_TO_LEFT, SINGLE_TO_RIGHT, SINGLE_TO_CENTER, INFIELD_SINGLE_TO_SHORT,
      INFIELD_SINGLE_TO_THIRD, INFIELD_SINGLE_TO_SECOND, INFIELD_SINGLE_TO_FIRST,
      INFIELD_SINGLE_TO_CATCHER, INFIELD_SINGLE_TO_PITCHER
      true
    else
      false
    end
  end

  def self.fielded(result)
    case result
    when POPUP_TO_PITCHER, POPUP_TO_CATCHER, POPUP_TO_FIRST, POPUP_TO_SECOND, POPUP_TO_SHORT,
          POPUP_TO_THIRD, GROUNDER_TO_PITCHER, GROUNDER_TO_CATCHER, GROUNDER_TO_FIRST,
          GROUNDER_TO_SECOND, GROUNDER_TO_SHORT, GROUNDER_TO_THIRD, LINER_TO_PITCHER,
          LINER_TO_FIRST, LINER_TO_SECOND, LINER_TO_SHORT, LINER_TO_THIRD, FLY_BALL_TO_LEFT,
          FLY_BALL_TO_CENTER, FLY_BALL_TO_RIGHT
      true
    else
      false
    end
  end
end
