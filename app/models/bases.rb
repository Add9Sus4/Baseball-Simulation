# The bases class. Used to handle all baserunning situations.
class Bases

  # Include some mathematical functions
  include Reusable

  # Attributes to keep track of base runners and other variables.
  attr_accessor :runs_scored, :status, :runner_on_first, :runner_on_second, :runner_on_third, :play_by_play, :over

  # Called at the beginning of the inning
  def initialize(inning_status, inning_number, home_team, away_team)
    @play_by_play = ""
    @home_team = home_team
    @away_team = away_team
    @inning_status = inning_status
    @inning_number = inning_number
    @status = BaseStatus::EMPTY
    @runner_on_first = nil
    @runner_on_second = nil
    @runner_on_third = nil
    @runs_scored = 0
    @over = false
  end

  # Returns the number of runs scored in this inning.
  def getRunsScored
    @runs_scored
  end

  # Update the bases on a hit
  def updateStatusOnHit(hit_result, batter, pitcher)
    @batter = batter
    @pitcher = pitcher
    @runs_scored = 0
    @hit_result = hit_result

    # Call the appropriate function based on the type of hit.
    if HitResult.is_a_single(hit_result)
      single
    elsif HitResult.is_a_double(hit_result)
      double
    elsif HitResult.is_a_triple(hit_result)
      triple
    elsif HitResult.is_a_home_run(hit_result)
      home_run
    end

  end

  # The runner on first steals second base.
  def runner_on_first_steals_second
    @play_by_play += "\n#{@runner_on_first.full_name} steals second.\n"
    @runner_on_first.steals_base
    runner_on_first_advances_to_second
    case @status
    when BaseStatus::RUNNER_ON_FIRST
      @status = BaseStatus::RUNNER_ON_SECOND
    when BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      @status = BaseStatus::RUNNERS_ON_SECOND_AND_THIRD
    end
  end

  # clear the bases
  def clear
    @status = BaseStatus::EMPTY
    @runner_on_first = nil
    @runner_on_second = nil
    @runner_on_third = nil
  end

  # The batter hits a single
  def single
    case @status
    when BaseStatus::EMPTY

      @status = BaseStatus::RUNNER_ON_FIRST
      batter_advances_to_first

    when BaseStatus::RUNNER_ON_FIRST

      case @hit_result
      when HitResult::SINGLE_TO_CENTER
        if rand() > 0.5
          runner_on_first_advances_to_second
          @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
        else
          runner_on_first_advances_to_third
          @status = BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
        end
      when HitResult::SINGLE_TO_RIGHT
        runner_on_first_advances_to_third
        @status = BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      else
        runner_on_first_advances_to_second
        @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
      end

      batter_advances_to_first

    when BaseStatus::RUNNER_ON_SECOND

      case @hit_result
      when HitResult::INFIELD_SINGLE_TO_PITCHER, HitResult::INFIELD_SINGLE_TO_CATCHER, HitResult::INFIELD_SINGLE_TO_SHORT, HitResult::INFIELD_SINGLE_TO_THIRD
        @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
      when HitResult::INFIELD_SINGLE_TO_FIRST, HitResult::INFIELD_SINGLE_TO_SECOND
        runner_on_second_advances_to_third
        @status = BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      else
        runner_on_second_scores
        @status = BaseStatus::RUNNER_ON_FIRST
      end

      batter_advances_to_first

    when BaseStatus::RUNNER_ON_THIRD

      if HitResult.is_infield_single(@hit_result)
        @status = BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      else
        runner_on_third_scores
        @status = BaseStatus::RUNNER_ON_FIRST
      end

      batter_advances_to_first

    when BaseStatus::RUNNERS_ON_FIRST_AND_SECOND

      case @hit_result
      when HitResult::SINGLE_TO_CENTER
        if rand() > 0.5
          runner_on_second_scores
          runner_on_first_advances_to_second
          @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
        else
          runner_on_second_scores
          runner_on_first_advances_to_third
          @status = BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
        end
      when HitResult::SINGLE_TO_RIGHT
        runner_on_second_scores
        runner_on_first_advances_to_third
        @status = BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      when HitResult::SINGLE_TO_LEFT
        runner_on_second_scores
        runner_on_first_advances_to_second
        @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
      when HitResult::INFIELD_SINGLE_TO_FIRST, HitResult::INFIELD_SINGLE_TO_THIRD, HitResult::INFIELD_SINGLE_TO_SHORT,
        HitResult::INFIELD_SINGLE_TO_SECOND, HitResult::INFIELD_SINGLE_TO_PITCHER, HitResult::INFIELD_SINGLE_TO_CATCHER
        runner_on_second_advances_to_third
        runner_on_first_advances_to_second
        @status = BaseStatus::LOADED
      end

      batter_advances_to_first

    when BaseStatus::RUNNERS_ON_SECOND_AND_THIRD

      if HitResult.is_infield_single(@hit_result)
        @status = BaseStatus::LOADED
      else
        runner_on_third_scores
        runner_on_second_scores
        @status = BaseStatus::RUNNER_ON_FIRST
      end

      batter_advances_to_first
    when BaseStatus::RUNNERS_ON_FIRST_AND_THIRD

      if HitResult.is_infield_single(@hit_result)
        runner_on_first_advances_to_second
        @status = BaseStatus::LOADED
      elsif @hit_result == HitResult::SINGLE_TO_LEFT
        runner_on_third_scores
        runner_on_first_advances_to_second
        @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
      elsif @hit_result == HitResult::SINGLE_TO_CENTER
        runner_on_third_scores
        if rand() > 0.50
          runner_on_first_advances_to_second
          @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
        else
          runner_on_first_advances_to_third
          @status = BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
        end
      elsif @hit_result == HitResult::SINGLE_TO_RIGHT
        runner_on_third_scores
        runner_on_first_advances_to_third
        @status = BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      end

      batter_advances_to_first
    when BaseStatus::LOADED

      if HitResult.is_infield_single(@hit_result)
        runner_on_third_scores
        runner_on_second_advances_to_third
        runner_on_first_advances_to_second
        @status = BaseStatus::LOADED
      elsif @hit_result == HitResult::SINGLE_TO_LEFT
        runner_on_third_scores
        runner_on_second_scores
        runner_on_first_advances_to_second
        @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
      elsif @hit_result == HitResult::SINGLE_TO_CENTER
        runner_on_third_scores
        runner_on_second_scores
        if rand() > 0.50
          runner_on_first_advances_to_second
          @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
        else
          runner_on_first_advances_to_third
          @status = BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
        end
      elsif @hit_result == HitResult::SINGLE_TO_RIGHT
        runner_on_third_scores
        runner_on_second_scores
        runner_on_first_advances_to_third
        @status = BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      end

      batter_advances_to_first
    end
  end

  # Batter hits a double
  def double
    case @status
    when BaseStatus::EMPTY
      batter_advances_to_second
      @status = BaseStatus::RUNNER_ON_SECOND
    when BaseStatus::RUNNER_ON_FIRST
      runner_on_first_advances_to_third
      batter_advances_to_second
      @status = BaseStatus::RUNNERS_ON_SECOND_AND_THIRD
    when BaseStatus::RUNNER_ON_SECOND
      runner_on_second_scores
      batter_advances_to_second
      @status = BaseStatus::RUNNER_ON_SECOND
    when BaseStatus::RUNNER_ON_THIRD
      runner_on_third_scores
      batter_advances_to_second
      @status = BaseStatus::RUNNER_ON_SECOND
    when BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
      runner_on_second_scores
      runner_on_first_advances_to_third
      batter_advances_to_second
      @status = BaseStatus::RUNNERS_ON_SECOND_AND_THIRD
    when BaseStatus::RUNNERS_ON_SECOND_AND_THIRD
      runner_on_third_scores
      runner_on_second_scores
      batter_advances_to_second
      @status = BaseStatus::RUNNER_ON_SECOND
    when BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      runner_on_third_scores
      runner_on_first_advances_to_third
      batter_advances_to_second
      @status = BaseStatus::RUNNERS_ON_SECOND_AND_THIRD
    when BaseStatus::LOADED
      runner_on_third_scores
      runner_on_second_scores
      runner_on_first_advances_to_third
      batter_advances_to_second
      @status = BaseStatus::RUNNERS_ON_SECOND_AND_THIRD
    end
  end

  # Batter hits a triple
  def triple
    case @status
    when BaseStatus::EMPTY
      batter_advances_to_third
      @status = BaseStatus::RUNNER_ON_THIRD
    when BaseStatus::RUNNER_ON_FIRST
      runner_on_first_scores
      batter_advances_to_third
      @status = BaseStatus::RUNNER_ON_THIRD
    when BaseStatus::RUNNER_ON_SECOND
      runner_on_second_scores
      batter_advances_to_third
      @status = BaseStatus::RUNNER_ON_THIRD
    when BaseStatus::RUNNER_ON_THIRD
      runner_on_third_scores
      batter_advances_to_third
      @status = BaseStatus::RUNNER_ON_THIRD
    when BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
      runner_on_second_scores
      runner_on_first_scores
      batter_advances_to_third
      @status = BaseStatus::RUNNER_ON_THIRD
    when BaseStatus::RUNNERS_ON_SECOND_AND_THIRD
      runner_on_third_scores
      runner_on_second_scores
      batter_advances_to_third
      @status = BaseStatus::RUNNER_ON_THIRD
    when BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      runner_on_third_scores
      runner_on_first_scores
      batter_advances_to_third
      @status = BaseStatus::RUNNER_ON_THIRD
    when BaseStatus::LOADED
      runner_on_third_scores
      runner_on_second_scores
      runner_on_first_scores
      batter_advances_to_third
      @status = BaseStatus::RUNNER_ON_THIRD
    end
  end

  # Batter hits a home run
  def home_run
    case @status
    when BaseStatus::EMPTY
      batter_scores
      @status = BaseStatus::EMPTY
    when BaseStatus::RUNNER_ON_FIRST
      runner_on_first_scores
      batter_scores
      @status = BaseStatus::EMPTY
    when BaseStatus::RUNNER_ON_SECOND
      runner_on_second_scores
      batter_scores
      @status = BaseStatus::EMPTY
    when BaseStatus::RUNNER_ON_THIRD
      runner_on_third_scores
      batter_scores
      @status = BaseStatus::EMPTY
    when BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
      runner_on_second_scores
      batter_scores
      @status = BaseStatus::EMPTY
    when BaseStatus::RUNNERS_ON_SECOND_AND_THIRD
      runner_on_third_scores
      runner_on_second_scores
      batter_scores
      @status = BaseStatus::EMPTY
    when BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      runner_on_third_scores
      runner_on_first_scores
      batter_scores
      @status = BaseStatus::EMPTY
    when BaseStatus::LOADED
      runner_on_third_scores
      runner_on_second_scores
      runner_on_first_scores
      batter_scores
      @status = BaseStatus::EMPTY
    end
  end

  # Update the bases on a walk or hit by pitch
  def updateStatusOnWalkOrHBP(batter, pitcher)
    @runs_scored = 0
    @batter = batter
    @pitcher = pitcher
    case @status
    when BaseStatus::EMPTY
      batter_advances_to_first
      @status = BaseStatus::RUNNER_ON_FIRST
    when BaseStatus::RUNNER_ON_FIRST
      runner_on_first_advances_to_second
      batter_advances_to_first
      @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
    when BaseStatus::RUNNER_ON_SECOND
      batter_advances_to_first
      @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
    when BaseStatus::RUNNER_ON_THIRD
      batter_advances_to_first
      @status = BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
    when BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
      runner_on_second_advances_to_third
      runner_on_first_advances_to_second
      batter_advances_to_first
      @status = BaseStatus::LOADED
    when BaseStatus::RUNNERS_ON_SECOND_AND_THIRD
      batter_advances_to_first
      @status = BaseStatus::LOADED
    when BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      runner_on_first_advances_to_second
      batter_advances_to_first
      @status = BaseStatus::LOADED
    when BaseStatus::LOADED
      runner_on_third_scores
      runner_on_second_advances_to_third
      runner_on_first_advances_to_second
      batter_advances_to_first
      @status = BaseStatus::LOADED
    end
  end

  # Increases the score by a given number. End the game if the home team just walked off.
  def increase_score(num_runs)

    @home_team_winning = false
    @away_team_winning = false
    @tied = false

    if @home_team.game_score > @away_team.game_score # Home team is winning
      @home_team_winning = true
    elsif @away_team.game_score > @home_team.game_score # Away team is winning
      @away_team_winning = true
    else # Game is tied
      @tied = true
    end

    if @inning_status == InningStatus::TOP # Top of the inning
      @away_team.game_score = @away_team.game_score + num_runs # Away team scores
      # If the home team was winning or tied, but now is losing
      if (@tied || @home_team_winning) && @home_team.game_score < @away_team.game_score
        @home_team.in_line_for_loss = @home_team.game_pitcher_list.last # Current home pitcher is in line for the loss
        @away_team.in_line_for_win = @away_team.game_pitcher_list.last # Current away pitcher is in line for the win
      end
    else # Bottom of the inning
      @home_team.game_score = @home_team.game_score + num_runs # Home team scores
      # If the away team was winning or tied, but now is losing
      if (@tied || @away_team_winning) && @away_team.game_score < @home_team.game_score
        @away_team.in_line_for_loss = @away_team.game_pitcher_list.last # Current away pitcher is in line for the loss
        @home_team.in_line_for_win = @home_team.game_pitcher_list.last # Current home pitcher is in line for the win
      end
    end
    @pitcher.allows_earned_run(num_runs)
    # If it was a walk off
    if @inning_number >= 9 && @home_team.game_score > @away_team.game_score
      @over = true
    end
  end

  def batter_scores
    @play_by_play += "<span style=\"color:" + color_good + "\"><strong><em>#{@batter.full_name} scores!</strong></em></span>\n"
    @batter.scores
    @runs_scored += 1
    @batter.records_rbi(1)
    increase_score(1)
  end

  def runner_on_first_scores
    @play_by_play += "<span style=\"color:" + color_good + "\"><strong><em>#{@runner_on_first.full_name} scores!</strong></em></span>\n"
    @runner_on_first.scores
    @runs_scored += 1
    @batter.records_rbi(1)
    @runner_on_first = nil
    increase_score(1)
  end

  def runner_on_second_scores
    @play_by_play += "<span style=\"color:" + color_good + "\"><strong><em>#{@runner_on_second.full_name} scores!</strong></em></span>\n"
    @runner_on_second.scores
    @runs_scored += 1
    @batter.records_rbi(1)
    @runner_on_second = nil
    increase_score(1)
  end

  def runner_on_third_scores
    @play_by_play += "<span style=\"color:" + color_good + "\"><strong><em>#{@runner_on_third.full_name} scores!</strong></em></span>\n"
    @runner_on_third.scores
    @runs_scored += 1
    @batter.records_rbi(1)
    @runner_on_third = nil
    increase_score(1)
  end

  def runners_on_first_and_second_score
    runner_on_second_scores
    runner_on_first_scores
  end

  def runners_on_second_and_third_score
    runner_on_third_scores
    runner_on_second_scores
  end

  def runners_on_first_and_third_score
    runner_on_third_scores
    runner_on_first_scores
  end

  def runners_on_first_second_and_third_score
    runner_on_third_scores
    runner_on_second_scores
    runner_on_first_scores
  end

  def runner_on_first_advances_to_second
    # @play_by_play += "#{@runner_on_first.full_name} advances to second.\n"
    @runner_on_second = @runner_on_first
  end

  def runner_on_first_advances_to_third
    # @play_by_play += "#{@runner_on_first.full_name} advances to third.\n"
    @runner_on_third = @runner_on_first
  end

  def runner_on_second_advances_to_third
    # @play_by_play += "#{@runner_on_second.full_name} advances to third.\n"
    @runner_on_third = @runner_on_second
  end

  def batter_advances_to_first
    # @play_by_play += "#{@batter.full_name} advances to first.\n"
    @runner_on_first = @batter
  end

  def batter_advances_to_second
    # @play_by_play += "#{@batter.full_name} advances to second.\n"
    @runner_on_second = @batter
  end

  def batter_advances_to_third
    # @play_by_play += "#{@batter.full_name} advances to third.\n"
    @runner_on_third = @batter
  end

end
