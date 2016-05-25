class Bases

  def initialize(game)
    @game = game
    @status = BaseStatus::EMPTY
    @runner_on_first = nil
    @runner_on_second = nil
    @runner_on_third = nil
  end

  # Update the bases on a hit
  def updateStatusOnHit(hit_result, batter, pitcher)
    @batter = batter
    @pitcher = pitcher
    case hit_result
    when HitResult::SINGLE
      single
    when HitResult::DOUBLE
      double
    when HitResult::TRIPLE
      triple
    when HitResult::HOME_RUN
      home_run
    end
  end

  def single
    case @status
    when BaseStatus::EMPTY
      batter_advances_to_first
      @status = BaseStatus::RUNNER_ON_FIRST
    when BaseStatus::RUNNER_ON_FIRST
      runner_on_first_advances_to_second
      batter_advances_to_first
      @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
    when BaseStatus::RUNNER_ON_SECOND
      runner_on_second_scores
      batter_advances_to_first
      @status = BaseStatus::RUNNER_ON_FIRST
    when BaseStatus::RUNNER_ON_THIRD
      runner_on_third_scores
      batter_advances_to_first
      @status = BaseStatus::RUNNER_ON_FIRST
    when BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
      runner_on_second_scores
      runner_on_first_advances_to_second
      batter_advances_to_first
      @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
    when BaseStatus::RUNNERS_ON_SECOND_AND_THIRD
      runner_on_third_scores
      runner_on_second_scores
      batter_advances_to_first
      @status = BaseStatus::RUNNER_ON_FIRST
    when BaseStatus::RUNNERS_ON_FIRST_AND_THIRD
      runner_on_third_scores
      runner_on_first_advances_to_second
      batter_advances_to_first
      @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
    when BaseStatus::LOADED
      runner_on_third_scores
      runner_on_second_scores
      runner_on_first_advances_to_second
      batter_advances_to_first
      @status = BaseStatus::RUNNERS_ON_FIRST_AND_SECOND
    end
  end

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

  def increase_score(num_runs)
    if @game.inning_status == InningStatus::TOP
      @game.away_team_score = @game.away_team_score + num_runs
    else
      @game.home_team_score = @game.home_team_score + num_runs
    end
    @pitcher.allows_earned_run(num_runs)
  end

  def batter_scores
    puts "#{@batter.full_name} scores!"
    @batter.scores
    @batter.records_rbi(1)
    increase_score(1)
  end

  def runner_on_first_scores
    puts "#{@runner_on_first.full_name} scores!"
    @runner_on_first.scores
    @batter.records_rbi(1)
    @runner_on_first = nil
    increase_score(1)
  end

  def runner_on_second_scores
    puts "#{@runner_on_second.full_name} scores!"
    @runner_on_second.scores
    @batter.records_rbi(1)
    @runner_on_second = nil
    increase_score(1)
  end

  def runner_on_third_scores
    puts "#{@runner_on_third.full_name} scores!"
    @runner_on_third.scores
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
    puts "#{@runner_on_first.full_name} advances to second."
    @runner_on_second = @runner_on_first
  end

  def runner_on_first_advances_to_third
    puts "#{@runner_on_first.full_name} advances to third."
    @runner_on_third = @runner_on_first
  end

  def runner_on_second_advances_to_third
    puts "#{@runner_on_second.full_name} advances to third."
    @runner_on_third = @runner_on_second
  end

  def batter_advances_to_first
    puts "#{@batter.full_name} advances to first."
    @runner_on_first = @batter
  end

  def batter_advances_to_second
    puts "#{@batter.full_name} advances to second."
    @runner_on_second = @batter
  end

  def batter_advances_to_third
    puts "#{@batter.full_name} advances to third."
    @runner_on_third = @batter
  end

end
