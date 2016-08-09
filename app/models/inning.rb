class Inning
  include Reusable

  def initialize(game)
    @game = game
    @outs = 0
    @bases = Bases.new(game)
    @over = false
    @runs_scored = 0
    if game.inning_status == InningStatus::TOP
      @hitting_team = game.away_team
      @fielding_team = game.home_team
      @lineup_position = game.away_team_lineup_position
      @pitcher = game.home_pitcher_list.last
    else
      @hitting_team = game.home_team
      @fielding_team = game.away_team
      @lineup_position = game.home_team_lineup_position
      @pitcher = game.away_pitcher_list.last
    end
    # Simulate inning
    while !@over do
      @batter = @hitting_team.find_player_by_lineup_index(@lineup_position)

      # Check if a pitching change is needed
      check_for_pitching_change

      atBat = AtBat.new(@pitcher, @batter, @game, @bases)
      play = Play.new(atBat, @game)
      if play.result == PlayResult::OUT
        @pitcher.records_out(1)
        @outs = @outs + 1
      elsif play.result == PlayResult::DOUBLE_PLAY
        @game.play_by_play += "\nDouble play\n"
        @outs = @outs + 2
      elsif play.result == PlayResult::TRIPLE_PLAY
        @game.play_by_play += "\nTriple play\n"
        @outs = @outs + 3
      elsif atBat.result == AtBatResult::WALK || atBat.result == AtBatResult::HBP
        @bases.updateStatusOnWalkOrHBP(@batter, @pitcher)
      else
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
        @bases.updateStatusOnHit(play.hit_result, @batter, @pitcher)
      end
      @runs_scored += @bases.runs_scored
      @bases.runs_scored = 0
      @lineup_position = @lineup_position + 1
      if @lineup_position > 8
        @lineup_position = 0
      end
      if @outs == 3
        @over = true
      end
    end
    if game.inning_status == InningStatus::TOP
      if @lineup_position > 8
        @lineup_position = 0
      end
      game.away_team_lineup_position = @lineup_position
      game.away_team_inning_scores += @runs_scored.to_s
      game.away_team_inning_scores += "_"
    else
      if @lineup_position > 8
        @lineup_position = 0
      end
      game.home_team_lineup_position = @lineup_position
      game.home_team_inning_scores += @runs_scored.to_s
      game.home_team_inning_scores += "_"
    end

    @game.play_by_play += "\n<h5><strong>Score: #{@game.away_team.full_name}: #{@game.away_team_score}, #{@game.home_team.full_name}: #{@game.home_team_score}</strong></h5>\n"
  end

  # Check to see if a pitching change is necessary
  def check_for_pitching_change
    @tiredness = (132 - @pitcher.endurance).to_f*@pitcher.game_total_pitches.to_f/78947.0

    # If the pitcher is too tired, substitute
    if @tiredness > rand()
      case @game.inning_number
      # Innings 1-4: LR
      when 1..4
        put_in_long_reliever
      # Innings 5-7: MR
      when 5..7
        put_in_middle_reliever
      # Inning 8: SU
      when 8
        put_in_setup
      # Inning 9: CL
      when 9..1000
        put_in_closer
      end
      if @game.inning_status == InningStatus::TOP
        @pitcher = @game.home_pitcher_list.last
      else
        @pitcher = @game.away_pitcher_list.last
      end
    end
  end

  def put_in_long_reliever
    # Home team pitching
    if @game.inning_status == InningStatus::TOP
      # If the long reliever has already pitched, put in middle reliever
      if @game.home_pitcher_list.any? {|player| player[:id] == @game.home_team.lr }
        put_in_middle_reliever
      else # Put in the long reliever
        @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.home_team.lr).full_name} enters for #{@game.home_pitcher_list.last.full_name}.</strong></h5>\n"
        @game.home_pitcher_list.push(Player.find(@game.home_team.lr))
        @game.home_pitcher_list.last.set_initial_stats
      end
    else # Away team pitching
      # If the long reliever has already pitched, put in middle reliever
      if @game.away_pitcher_list.any? {|player| player[:id] == @game.away_team.lr }
        put_in_middle_reliever
      else # Put in the long reliever
        @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.away_team.lr).full_name} enters for #{@game.away_pitcher_list.last.full_name}.</strong></h5>\n"
        @game.away_pitcher_list.push(Player.find(@game.away_team.lr))
        @game.away_pitcher_list.last.set_initial_stats
      end
    end
  end

  def put_in_middle_reliever
    # Home team pitching
    if @game.inning_status == InningStatus::TOP
      # If the MR1 has already pitched
      if @game.home_pitcher_list.any? {|player| player[:id] == @game.home_team.mr1}
        # If the MR2 has also already pitched
        if @game.home_pitcher_list.any? {|player| player[:id] == @game.home_team.mr2}
          # If the MR3 has also already pitched
          if @game.home_pitcher_list.any? {|player| player[:id] == @game.home_team.mr3}
            put_in_setup
          else # The MR3 has not yet pitched
            @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.home_team.mr3).full_name} enters for #{@game.home_pitcher_list.last.full_name}.</strong></h5>\n"
            @game.home_pitcher_list.push(Player.find(@game.home_team.mr3))
            @game.home_pitcher_list.last.set_initial_stats
          end
        else # The MR2 has not yet pitched
          @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.home_team.mr2).full_name} enters for #{@game.home_pitcher_list.last.full_name}.</strong></h5>\n"
          @game.home_pitcher_list.push(Player.find(@game.home_team.mr2))
          @game.home_pitcher_list.last.set_initial_stats
        end
      else # The MR1 has not yet pitched
        @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.home_team.mr1).full_name} enters for #{@game.home_pitcher_list.last.full_name}.</strong></h5>\n"
        @game.home_pitcher_list.push(Player.find(@game.home_team.mr1))
        @game.home_pitcher_list.last.set_initial_stats
      end
    else # Away team pitching
      # If the MR1 has already pitched
      if @game.away_pitcher_list.any? {|player| player[:id] == @game.away_team.mr1}
        # If the MR2 has also already pitched
        if @game.away_pitcher_list.any? {|player| player[:id] == @game.away_team.mr2}
          # If the MR3 has also already pitched
          if @game.away_pitcher_list.any? {|player| player[:id] == @game.away_team.mr3}
            put_in_setup
          else # The MR3 has not yet pitched
            @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.away_team.mr3).full_name} enters for #{@game.away_pitcher_list.last.full_name}.</strong></h5>\n"
            @game.away_pitcher_list.push(Player.find(@game.away_team.mr3))
            @game.away_pitcher_list.last.set_initial_stats
          end
        else # The MR2 has not yet pitched
          @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.away_team.mr2).full_name} enters for #{@game.away_pitcher_list.last.full_name}.</strong></h5>\n"
          @game.away_pitcher_list.push(Player.find(@game.away_team.mr2))
          @game.away_pitcher_list.last.set_initial_stats
        end
      else # The MR1 has not yet pitched
        @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.away_team.mr1).full_name} enters for #{@game.away_pitcher_list.last.full_name}.</strong></h5>\n"
        @game.away_pitcher_list.push(Player.find(@game.away_team.mr1))
        @game.away_pitcher_list.last.set_initial_stats
      end
    end
  end

  def put_in_setup
    # Home team pitching
    if @game.inning_status == InningStatus::TOP
      # If the SU1 has already pitched
      if @game.home_pitcher_list.any? {|player| player[:id] == @game.home_team.su1}
        # If the SU2 has already pitched
        if @game.home_pitcher_list.any? {|player| player[:id] == @game.home_team.su2}
          put_in_closer
        else # The SU2 has not yet pitched
          @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.home_team.su2).full_name} enters for #{@game.home_pitcher_list.last.full_name}.</strong></h5>\n"
          @game.home_pitcher_list.push(Player.find(@game.home_team.su2))
          @game.home_pitcher_list.last.set_initial_stats
        end
      else # The SU1 has not yet pitched
        @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.home_team.su1).full_name} enters for #{@game.home_pitcher_list.last.full_name}.</strong></h5>\n"
        @game.home_pitcher_list.push(Player.find(@game.home_team.su1))
        @game.home_pitcher_list.last.set_initial_stats
      end
    else # Away team pitching
      # If the SU1 has already pitched
      if @game.away_pitcher_list.any? {|player| player[:id] == @game.away_team.su1}
        # If the SU2 has already pitched
        if @game.away_pitcher_list.any? {|player| player[:id] == @game.away_team.su2}
          put_in_closer
        else # The SU2 has not yet pitched
          @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.away_team.su2).full_name} enters for #{@game.away_pitcher_list.last.full_name}.</strong></h5>\n"
          @game.away_pitcher_list.push(Player.find(@game.away_team.su2))
          @game.away_pitcher_list.last.set_initial_stats
        end
      else # The SU1 has not yet pitched
        @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.away_team.su1).full_name} enters for #{@game.away_pitcher_list.last.full_name}.</strong></h5>\n"
        @game.away_pitcher_list.push(Player.find(@game.away_team.su1))
        @game.away_pitcher_list.last.set_initial_stats
      end
    end
  end

  def put_in_closer
    # Home team pitching
    if @game.inning_status == InningStatus::TOP
      # If the CL has already pitched
      if @game.home_pitcher_list.any? {|player| player[:id] == @game.home_team.cl}
        put_in_long_reliever
      else # The CL has not yet pitched
        @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.home_team.cl).full_name} enters for #{@game.home_pitcher_list.last.full_name}.</strong></h5>\n"
        @game.home_pitcher_list.push(Player.find(@game.home_team.cl))
        @game.home_pitcher_list.last.set_initial_stats
      end
    else # Away team pitching
      # If the CL has already pitched
      if @game.away_pitcher_list.any? {|player| player[:id] == @game.away_team.cl}
        put_in_long_reliever
      else # The CL has not yet pitched
        @game.play_by_play += "\n<h5><strong>Pitching change: #{Player.find(@game.away_team.cl).full_name} enters for #{@game.away_pitcher_list.last.full_name}.</strong></h5>\n"
        @game.away_pitcher_list.push(Player.find(@game.away_team.cl))
        @game.away_pitcher_list.last.set_initial_stats
      end
    end
  end

end
