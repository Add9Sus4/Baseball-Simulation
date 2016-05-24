class Inning

  def initialize(hitting_team, fielding_team, heat_maps)
    @outs = 0
    @bases = Bases::EMPTY
    @over = false
    @hitting_team = hitting_team
    @fielding_team = fielding_team
    @heat_maps = heat_maps

    puts "Inning started"
    # Simulate inning
    while !@over do
      atBat = AtBat.new(@fielding_team.players[0], @hitting_team.players[0], @heat_maps)
      play = Play.new(atBat)
      if play.result == PlayResult::OUT
        puts "Out recorded"
        @outs = @outs + 1
      elsif play.result == PlayResult::DOUBLE_PLAY
        puts "Double play"
        @outs = @outs + 2
      elsif play.result == PlayResult::TRIPLE_PLAY
        puts "Triple play"
        @outs = @outs + 3
      else
        puts "No out recorded"
      end

      if @outs == 3
        puts "Inning over"
        @over = true
      end

    end
  end

end
