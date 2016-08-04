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
    else
      @hitting_team = game.home_team
      @fielding_team = game.away_team
      @lineup_position = game.home_team_lineup_position
    end
    # Simulate inning
    while !@over do
      @batter = @hitting_team.find_player_by_lineup_index(@lineup_position)
      @pitcher = @fielding_team.players[0]
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

end
