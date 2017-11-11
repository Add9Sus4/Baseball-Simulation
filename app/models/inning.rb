class Inning

  attr_accessor :play_by_play

  include Reusable

  def initialize(inning_status, inning_number, home_team, away_team)
    @play_by_play = ""
    @inning_status = inning_status
    @inning_number = inning_number
    @home_team = home_team
    @away_team = away_team
    @outs = 0
    @bases = Bases.new(inning_status, inning_number, home_team, away_team)
    @over = false
    @runs_scored = 0
    if @inning_status == InningStatus::TOP
      @hitting_team = away_team
      @fielding_team = home_team
      @lineup_position = @away_team.game_lineup_position
      @pitcher = @home_team.game_pitcher_list.last
    else
      @hitting_team = home_team
      @fielding_team = away_team
      @lineup_position = @home_team.game_lineup_position
      @pitcher = @away_team.game_pitcher_list.last
    end
    # Simulate inning
    while !@over do
      # Exit on walk-off

      #TODO: Make sure that if a walk-off home run is hit, all the runs are counted before the game ends

      if @inning_status == InningStatus::BOTTOM && @inning_number >= 9 && @home_team.game_score > @away_team.game_score
        @over = true
        break
      end

      @batter = @hitting_team.game_lineup_players[@lineup_position]

      # Check if a pitching change is needed
      check_for_pitching_change

      atBat = AtBat.new(@pitcher, @batter, @fielding_team, @bases)
      @play_by_play += atBat.play_by_play
      play = Play.new(atBat, @bases)
      @play_by_play += play.play_by_play
      if play.result == PlayResult::OUT # Play resulted in an out
        @pitcher.records_out(1)
        @outs = @outs + 1
      elsif play.result == PlayResult::DOUBLE_PLAY
        @play_by_play += "\nDouble play\n"
        @outs = @outs + 2
      elsif play.result == PlayResult::TRIPLE_PLAY
        @play_by_play += "\nTriple play\n"
        @outs = @outs + 3
      elsif atBat.result == AtBatResult::WALK || atBat.result == AtBatResult::HBP
        @bases.play_by_play = "" # Need to clear play-by-play for bases
        @bases.updateStatusOnWalkOrHBP(@batter, @pitcher)
        @play_by_play += @bases.play_by_play
        @bases.play_by_play = "" # Need to clear play-by-play for base
      else # Play did not result in an out
        if HitResult.is_a_single(play.hit_result)
          @batter.hits_single
          @pitcher.allows_hit
        elsif HitResult.is_a_double(play.hit_result)
          @batter.hits_double
          @pitcher.allows_hit
        elsif HitResult.is_a_triple(play.hit_result)
          @batter.hits_triple
          @pitcher.allows_hit
        elsif HitResult.is_a_home_run(play.hit_result)
          @batter.hits_home_run
          @pitcher.allows_hit
          @pitcher.allows_home_run
        end
        @bases.play_by_play = "" # Need to clear play-by-play for bases
        @bases.updateStatusOnHit(play.hit_result, @batter, @pitcher)
        @play_by_play += @bases.play_by_play
        @bases.play_by_play = "" # Need to clear play-by-play for base
      end # End play
      @runs_scored += @bases.runs_scored
      @bases.runs_scored = 0
      @lineup_position = @lineup_position + 1
      if @lineup_position > 8
        @lineup_position = 0
      end
      if @outs == 3
        @over = true
      end
    end # End inning
    if @inning_status == InningStatus::TOP
      if @lineup_position > 8
        @lineup_position = 0
      end
      @away_team.game_lineup_position = @lineup_position
      @away_team.game_inning_scores += @runs_scored.to_s
      @away_team.game_inning_scores += "_"
    else
      if @lineup_position > 8
        @lineup_position = 0
      end
      @home_team.game_lineup_position = @lineup_position
      @home_team.game_inning_scores += @runs_scored.to_s
      @home_team.game_inning_scores += "_"
    end

    @play_by_play += "\n<h5><strong>Score: #{@away_team.full_name}: #{@away_team.game_score}, #{@home_team.full_name}: #{@home_team.game_score}</strong></h5>\n"
  end

  # Check to see if a pitching change is necessary
  def check_for_pitching_change

    # First, check if the player is a starting pitcher

    # Pitcher is starter
    if @pitcher.is_starting_pitcher

      # Check if runs allowed threshold has been reached
      if @pitcher.game_runs_allowed >= 6 # Runs allowed threshold has been reached; pitcher is eligible for removal due to poor performance
        if rand() < 0.25
          make_pitching_change # Remove pitcher for poor performance
        end
      else # Runs allowed threshold has not been reached; pitcher cannot be removed due to poor performance

        # Check if the pitcher has reached the energy threshold
        if @pitcher.game_current_energy <= 0 # Energy has been reached; pitcher is eligible for removal due to tiredness
          if rand() < 0.25
            make_pitching_change # Remove pitcher due to tiredness
          end
        end
      end
    else # Pitcher is reliever

      # Check if runs allowed threshold has been reached
      if @pitcher.game_runs_allowed >= 3 # Runs allowed threshold has been reached; pitcher is eligible for removal due to poor performance
        if rand() < 0.25
          make_pitching_change # Remove pitcher for poor performance
        end
      else # Runs allowed threshold has not been reached; pitcher cannot be removed due to poor performance

        # Check if the pitcher has reached the energy threshold
        if @pitcher.game_current_energy <= 0 # Pitches thrown threshold has been reached; pitcher is eligible for removal due to tiredness
          if rand() < 0.25
            make_pitching_change # Remove pitcher due to tiredness
          end
        end

        # TODO: Check if the manager wishes to make a pitching change for strategic reasons

      end
    end

  end

  # Perform a pitching change
  def make_pitching_change
    # Make sure there are available pitchers remaining
    if @fielding_team.game_pitcher_list.length >= 6
      return
    end
    case @inning_number
    # Innings 1-4: LR
    when 1..4
      put_in_long_reliever
    # Innings 5-6: MR
    when 5..6
      put_in_middle_reliever
    # Inning 7: MR or SU
    when 7
      if rand() > 0.50
        put_in_middle_reliever
      else
        put_in_setup
      end
    # Inning 8: SU
    when 8
      put_in_setup
    # Inning 9: CL
    when 9..1000
      put_in_closer
    end


  end

  def put_in_long_reliever
    # If the long reliever has already pitched, put in middle reliever
    if @fielding_team.game_pitcher_list.any? {|player| player[:id] == @fielding_team.lr }
      put_in_middle_reliever
    else # Put in the long reliever
      # Only make pitching change if the long reliever isn't too tired
      if Player.find(@fielding_team.lr).current_energy >= 0
        @play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@fielding_team.lr).full_name} (Long relief) enters for #{@fielding_team.game_pitcher_list.last.full_name}.</strong></h5>\n"
        @fielding_team.game_pitcher_list.push(Player.find(@fielding_team.lr))
        @fielding_team.game_pitcher_list.last.set_initial_stats
        # Set current pitcher to the new pitcher that was just put in
        @pitcher = @fielding_team.game_pitcher_list.last
      end
    end
  end

  def put_in_middle_reliever
    # If the MR1 has already pitched
    if @fielding_team.game_pitcher_list.any? {|player| player[:id] == @fielding_team.mr1} || rand() > 0.50
      # If the MR2 has also already pitched
      if @fielding_team.game_pitcher_list.any? {|player| player[:id] == @fielding_team.mr2} || rand() > 0.50
        # If the MR3 has also already pitched
        if @fielding_team.game_pitcher_list.any? {|player| player[:id] == @fielding_team.mr3}
          put_in_setup
        else # The MR3 has not yet pitched
          if Player.find(@fielding_team.mr3).current_energy >= 0
            @play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@fielding_team.mr3).full_name} (Middle relief) enters for #{@fielding_team.game_pitcher_list.last.full_name}.</strong></h5>\n"
            @fielding_team.game_pitcher_list.push(Player.find(@fielding_team.mr3))
            @fielding_team.game_pitcher_list.last.set_initial_stats
          end
        end
      else # The MR2 has not yet pitched
        if Player.find(@fielding_team.mr2).current_energy >= 0
          @play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@fielding_team.mr2).full_name} (Middle relief) enters for #{@fielding_team.game_pitcher_list.last.full_name}.</strong></h5>\n"
          @fielding_team.game_pitcher_list.push(Player.find(@fielding_team.mr2))
          @fielding_team.game_pitcher_list.last.set_initial_stats
        end
      end
    else # The MR1 has not yet pitched
      if Player.find(@fielding_team.mr1).current_energy >= 0
        @play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@fielding_team.mr1).full_name} (Middle relief) enters for #{@fielding_team.game_pitcher_list.last.full_name}.</strong></h5>\n"
        @fielding_team.game_pitcher_list.push(Player.find(@fielding_team.mr1))
        @fielding_team.game_pitcher_list.last.set_initial_stats
      end
    end
  end

  def put_in_setup
    # If the SU1 has already pitched
    if @fielding_team.game_pitcher_list.any? {|player| player[:id] == @fielding_team.su1} || rand() > 0.66
      # If the SU2 has already pitched
      if @fielding_team.game_pitcher_list.any? {|player| player[:id] == @fielding_team.su2}
        put_in_closer
      else # The SU2 has not yet pitched
        if Player.find(@fielding_team.su2).current_energy >= 0
          @play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@fielding_team.su2).full_name} (Setup) enters for #{@fielding_team.game_pitcher_list.last.full_name}.</strong></h5>\n"
          @fielding_team.game_pitcher_list.push(Player.find(@fielding_team.su2))
          @fielding_team.game_pitcher_list.last.set_initial_stats
        end
      end
    else # The SU1 has not yet pitched
      if Player.find(@fielding_team.su1).current_energy >= 0
        @play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@fielding_team.su1).full_name} (Setup) enters for #{@fielding_team.game_pitcher_list.last.full_name}.</strong></h5>\n"
        @fielding_team.game_pitcher_list.push(Player.find(@fielding_team.su1))
        @fielding_team.game_pitcher_list.last.set_initial_stats
      end
    end
  end

  def put_in_closer
    # If the CL has already pitched
    if @fielding_team.game_pitcher_list.any? {|player| player[:id] == @fielding_team.cl}
      put_in_long_reliever
    else # The CL has not yet pitched
      if Player.find(@fielding_team.cl).current_energy >= 0
        @play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@fielding_team.cl).full_name} (Closer) enters for #{@fielding_team.game_pitcher_list.last.full_name}.</strong></h5>\n"
        @fielding_team.game_pitcher_list.push(Player.find(@fielding_team.cl))
        @fielding_team.game_pitcher_list.last.set_initial_stats
      end
    end
  end

end
