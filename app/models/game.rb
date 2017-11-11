# If we access the database every time we want to reference a heat map value,
# then a game takes roughly 90 seconds to simulate.
# If we load the heat maps first and then simulate the game, the total duration
# is 65 seconds. Since loading the heat maps takes roughly 60 seconds, the game
# simulation only takes 5 seconds to complete with the heat maps loaded into
# memory. Therefore, game simulation runs almost 20 times faster if all the
# heat maps are loaded into a hash before the game begins
class Game < ActiveRecord::Base
  include Reusable
  validate :teams_must_be_different
  attr_accessor :play_by_play, :home_team, :away_team, :inning_status, :inning_number, :over

  def teams_must_be_different
    errors.add(:base, "Teams cannot be the same") if home_team_id == away_team_id
  end

  # Prepare for the game
  def prepare home_team, away_team, game_num, season_num
    @game_date = Season.first.current_date
    @home_team = home_team
    @away_team = away_team
    @game_number = game_num
    @season_id = season_num

    @over = false
    @inning_number = 1
    @inning_status = InningStatus::TOP
    @play_by_play = ""

    # home and away team stats
    @home_team.game_score = 0
    @away_team.game_score = 0
    @home_team.game_inning_scores = ""
    @away_team.game_inning_scores = ""
    @home_team.in_line_for_win = nil # id of pitcher in line to get the win
    @home_team.in_line_for_loss = nil # id of pitcher in line to get the loss
    @away_team.in_line_for_win = nil # id of pitcher in line to get the win
    @away_team.in_line_for_loss = nil # id of pitcher in line to get the loss
    @home_team.game_lineup_position = 0
    @away_team.game_lineup_position = 0

    # put players on home team
    @home_team.players.each do |player|
      player.set_initial_stats
    end

    # put players on away team
    @away_team.players.each do |player|
      player.set_initial_stats
    end

    # stadium data
    stadium_name = @home_team.stadium
    attendance = rand(30000..60000) #TODO: make this more sophisticated (stadium size, team performance, etc)

    # lineups
    @home_team.game_lineup = ""
    @away_team.game_lineup = ""
    @home_team.game_lineup_players = []
    @away_team.game_lineup_players = []
    for i in 1..9 do
      @home_team.game_lineup += "#{@home_team.find_player_by_lineup_index(i).id}"
      @away_team.game_lineup += "#{@away_team.find_player_by_lineup_index(i).id}"
      @home_team.game_lineup_players.push(@home_team.find_player_by_lineup_index(i))
      @away_team.game_lineup_players.push(@away_team.find_player_by_lineup_index(i))
      if i < 9
        @home_team.game_lineup += "_"
        @away_team.game_lineup += "_"
      end
    end

    # initialize stats for players in lineup
    @home_team.game_lineup_players.each do |player|
      player.set_initial_stats
    end
    @away_team.game_lineup_players.each do |player|
      player.set_initial_stats
    end

    # positions
    @home_team.game_position_players = {
      "C" => Player.find(@home_team.catcher),
      "1B" => Player.find(@home_team.first_base),
      "2B" => Player.find(@home_team.second_base),
      "3B" => Player.find(@home_team.third_base),
      "SS" => Player.find(@home_team.shortstop),
      "LF" => Player.find(@home_team.left_field),
      "CF" => Player.find(@home_team.center_field),
      "RF" => Player.find(@home_team.right_field)
    }

    @away_team.game_position_players = {
      "C" => Player.find(@away_team.catcher),
      "1B" => Player.find(@away_team.first_base),
      "2B" => Player.find(@away_team.second_base),
      "3B" => Player.find(@away_team.third_base),
      "SS" => Player.find(@away_team.shortstop),
      "LF" => Player.find(@away_team.left_field),
      "CF" => Player.find(@away_team.center_field),
      "RF" => Player.find(@away_team.right_field)
    }

    @home_team.game_position_players.each do |key, player|
      player.set_initial_stats
    end
    @away_team.game_position_players.each do |key, player|
      player.set_initial_stats
    end

    # pitching list
    @home_team.game_pitcher_list = []
    @away_team.game_pitcher_list = []
    @home_team.game_pitcher_list.push(@home_team.starting_pitcher)
    @away_team.game_pitcher_list.push(@away_team.starting_pitcher)
    @home_team.game_pitcher_list.each do |pitcher|
      pitcher.set_initial_stats
    end

    @away_team.game_pitcher_list.each do |pitcher|
      pitcher.set_initial_stats
    end
  end

  # Plays a game
  def play
    # Simulate the game
    while !@over do
      # Top of inning
      unless @inning_number == 1 && @inning_status == InningStatus::TOP
        @play_by_play += "\n____________________________________________________________________________\n"
      end
      @play_by_play += "\n<h4><strong>Top of inning #{@inning_number} (#{@away_team.full_name} batting):</strong></h4>\n"
      @inning_status = InningStatus::TOP
      inning = Inning.new(@inning_status, @inning_number, @home_team, @away_team)
      @play_by_play += inning.play_by_play
      # Bottom of inning
      if @inning_number == 9 && @home_team.game_score > @away_team.game_score
        @over = true
      end
      @play_by_play += "\n____________________________________________________________________________\n"
      @play_by_play += "\n<h4><strong>Bottom of inning #{@inning_number} (#{@home_team.full_name} batting):</strong></h4>\n"
      @inning_status = InningStatus::BOTTOM
      inning = Inning.new(@inning_status, @inning_number, @home_team, @away_team)
      @play_by_play += inning.play_by_play
      if @inning_number > 8 && @home_team.game_score != @away_team.game_score
        @over = true
      end
      @inning_number = @inning_number + 1
    end # game is over here
    # puts 'game is over'
    collect_stats
  end

  def collect_stats

    home_wins = 0
    away_wins = 0
    home_losses = 0
    away_losses = 0
    home_streak = @home_team.streak
    away_streak = @away_team.streak

    # team win/loss stats
    # If the home team wins
    if @home_team.game_score > @away_team.game_score

      # Game w/l
      winning_pitcher = @home_team.in_line_for_win.id
      losing_pitcher = @away_team.in_line_for_loss.id

      # team w/l
      home_wins = 1
      away_losses = 1

      # pitcher w/l
      @home_team.in_line_for_win.update_attribute(:wins, @home_team.in_line_for_win.wins + 1)
      @away_team.in_line_for_loss.update_attribute(:losses, @away_team.in_line_for_loss.losses + 1)

      # Home team streak
      home_streak = home_streak >= 0 ? @home_team.streak + 1 : 1
      away_streak = away_streak <= 0 ? @away_team.streak - 1 : -1

    # If the away team wins
    else

      # Game w/l
      winning_pitcher = @away_team.in_line_for_win.id
      losing_pitcher = @home_team.in_line_for_loss.id

      # team w/l
      home_losses = 1
      away_wins = 1

      # pitcher w/l
      @away_team.in_line_for_win.update_attribute(:wins, @away_team.in_line_for_win.wins + 1)
      @home_team.in_line_for_loss.update_attribute(:losses, @home_team.in_line_for_loss.losses + 1)

      # Home team streak
      home_streak = home_streak <= 0 ? @home_team.streak - 1 : -1
      away_streak = away_streak >= 0 ? @away_team.streak + 1 : 1

    end

    # team runs scored and allowed
    @home_team.update_attributes(:runs_scored => @home_team.runs_scored + @home_team.game_score,
    :runs_allowed => @home_team.runs_allowed + @away_team.game_score,
    :rotation_position => @home_team.increment_rotation,
    :losses => @home_team.losses + home_losses,
    :wins => @home_team.wins + home_wins,
    :streak => home_streak)

    @away_team.update_attributes(:runs_scored => @away_team.runs_scored + @away_team.game_score,
    :runs_allowed => @away_team.runs_allowed + @home_team.game_score,
    :rotation_position => @away_team.increment_rotation,
    :losses => @away_team.losses + away_losses,
    :wins => @away_team.wins + away_wins,
    :streak => away_streak)

    # puts 'updating home player stats'

    # player stats
    @home_team.game_lineup_players.each do |player|
      player.atbats ||= 0
      player.runs ||= 0
      player.hits ||= 0
      player.doubles ||= 0
      player.triples ||= 0
      player.home_runs ||= 0
      player.rbi ||= 0
      player.walks ||= 0
      player.strikeouts ||= 0
      player.stolen_bases ||= 0
      player.caught_stealing ||= 0
      player.errors_committed ||= 0
      player.assists ||= 0
      player.putouts ||= 0
      player.chances ||= 0

      player.update_columns(:atbats => player.atbats + player.game_atbats,
      :runs => player.runs + player.game_runs_scored,
      :hits => player.hits + player.game_hits,
      :doubles => player.doubles + player.game_doubles,
      :triples => player.triples + player.game_triples,
      :home_runs => player.home_runs + player.game_home_runs,
      :rbi => player.rbi + player.game_rbi,
      :walks => player.walks + player.game_walks,
      :strikeouts => player.strikeouts + player.game_strikeouts,
      :stolen_bases => player.stolen_bases + player.game_stolen_bases,
      :caught_stealing => player.caught_stealing + player.game_caught_stealing,
      :errors_committed => player.errors_committed + player.game_errors_committed,
      :assists => player.assists + player.game_assists,
      :putouts => player.putouts + player.game_putouts,
      :chances => player.chances + player.game_chances)
    end

    # puts 'updating away player stats'

    @away_team.game_lineup_players.each do |player|

      player.atbats ||= 0
      player.runs ||= 0
      player.hits ||= 0
      player.doubles ||= 0
      player.triples ||= 0
      player.home_runs ||= 0
      player.rbi ||= 0
      player.walks ||= 0
      player.strikeouts ||= 0
      player.stolen_bases ||= 0
      player.caught_stealing ||= 0
      player.errors_committed ||= 0
      player.assists ||= 0
      player.putouts ||= 0
      player.chances ||= 0
      player.outs_recorded ||= 0
      player.hits_allowed ||= 0
      player.runs_allowed ||= 0
      player.earned_runs_allowed ||= 0
      player.walks_allowed ||= 0
      player.strikeouts_recorded ||= 0
      player.home_runs_allowed ||= 0
      player.total_pitches ||= 0
      player.strikes_thrown ||= 0
      player.balls_thrown ||= 0
      player.intentional_walks_allowed ||= 0

      player.update_columns(:atbats => player.atbats + player.game_atbats,
      :runs => player.runs + player.game_runs_scored,
      :hits => player.hits + player.game_hits,
      :doubles => player.doubles + player.game_doubles,
      :triples => player.triples + player.game_triples,
      :home_runs => player.home_runs + player.game_home_runs,
      :rbi => player.rbi + player.game_rbi,
      :walks => player.walks + player.game_walks,
      :strikeouts => player.strikeouts + player.game_strikeouts,
      :stolen_bases => player.stolen_bases + player.game_stolen_bases,
      :caught_stealing => player.caught_stealing + player.game_caught_stealing,
      :errors_committed => player.errors_committed + player.game_errors_committed,
      :assists => player.assists + player.game_assists,
      :putouts => player.putouts + player.game_putouts,
      :chances => player.chances + player.game_chances)
    end

    # puts 'updating home fielding stats'

    @home_team.game_position_players.each do |key, player|
      player.update_columns(:errors_committed => player.errors_committed + player.game_errors_committed,
        :chances => player.chances + player.game_chances,
        :putouts => player.putouts + player.game_putouts,
        :assists => player.assists + player.game_assists)
    end

    # puts 'updating away fielding stats'

    @away_team.game_position_players.each do |key, player|
      player.update_columns(:errors_committed => player.errors_committed + player.game_errors_committed,
        :chances => player.chances + player.game_chances,
        :putouts => player.putouts + player.game_putouts,
        :assists => player.assists + player.game_assists)
    end

    # puts 'updating home pitcher stats'

    # pitcher stats
    @home_team.game_pitcher_list.each do |player|

      player.errors_committed ||= 0
      player.assists ||= 0
      player.putouts ||= 0
      player.chances ||= 0
      player.outs_recorded ||= 0
      player.hits_allowed ||= 0
      player.runs_allowed ||= 0
      player.earned_runs_allowed ||= 0
      player.walks_allowed ||= 0
      player.strikeouts_recorded ||= 0
      player.home_runs_allowed ||= 0
      player.total_pitches ||= 0
      player.strikes_thrown ||= 0
      player.balls_thrown ||= 0
      player.intentional_walks_allowed ||= 0

      player.update_columns(:errors_committed => player.errors_committed + player.game_errors_committed,
      :assists => player.assists + player.game_assists,
      :putouts => player.putouts + player.game_putouts,
      :chances => player.chances + player.game_chances,
      :outs_recorded => player.outs_recorded + player.game_outs_recorded,
      :hits_allowed => player.hits_allowed + player.game_hits_allowed,
      :runs_allowed => player.runs_allowed + player.game_runs_allowed,
      :earned_runs_allowed => player.earned_runs_allowed + player.game_earned_runs_allowed,
      :walks_allowed => player.walks_allowed + player.game_walks_allowed,
      :strikeouts_recorded => player.strikeouts_recorded + player.game_strikeouts_recorded,
      :home_runs_allowed => player.home_runs_allowed + player.game_home_runs_allowed,
      :total_pitches => player.total_pitches + player.game_total_pitches,
      :strikes_thrown => player.strikes_thrown + player.game_strikes_thrown,
      :balls_thrown => player.balls_thrown + player.game_balls_thrown,
      :intentional_walks_allowed => player.intentional_walks_allowed + player.game_intentional_walks_allowed,
      :zone_1_pitches => player.zone_1_pitches + player.zone_pitches_thrown[0],
      :zone_2_pitches => player.zone_2_pitches + player.zone_pitches_thrown[1],
      :zone_3_pitches => player.zone_3_pitches + player.zone_pitches_thrown[2],
      :zone_4_pitches => player.zone_4_pitches + player.zone_pitches_thrown[3],
      :zone_5_pitches => player.zone_5_pitches + player.zone_pitches_thrown[4],
      :zone_6_pitches => player.zone_6_pitches + player.zone_pitches_thrown[5],
      :zone_7_pitches => player.zone_7_pitches + player.zone_pitches_thrown[6],
      :zone_8_pitches => player.zone_8_pitches + player.zone_pitches_thrown[7],
      :zone_9_pitches => player.zone_9_pitches + player.zone_pitches_thrown[8],
      :zone_10_pitches => player.zone_10_pitches + player.zone_pitches_thrown[9],
      :zone_11_pitches => player.zone_11_pitches + player.zone_pitches_thrown[10],
      :zone_12_pitches => player.zone_12_pitches + player.zone_pitches_thrown[11],
      :zone_13_pitches => player.zone_13_pitches + player.zone_pitches_thrown[12],
      :zone_14_pitches => player.zone_14_pitches + player.zone_pitches_thrown[13],
      :zone_15_pitches => player.zone_15_pitches + player.zone_pitches_thrown[14],
      :zone_16_pitches => player.zone_16_pitches + player.zone_pitches_thrown[15],
      :zone_17_pitches => player.zone_17_pitches + player.zone_pitches_thrown[16],
      :zone_18_pitches => player.zone_18_pitches + player.zone_pitches_thrown[17],
      :zone_19_pitches => player.zone_19_pitches + player.zone_pitches_thrown[18],
      :zone_20_pitches => player.zone_20_pitches + player.zone_pitches_thrown[19],
      :zone_21_pitches => player.zone_21_pitches + player.zone_pitches_thrown[20],
      :zone_22_pitches => player.zone_22_pitches + player.zone_pitches_thrown[21],
      :zone_23_pitches => player.zone_23_pitches + player.zone_pitches_thrown[22],
      :zone_24_pitches => player.zone_24_pitches + player.zone_pitches_thrown[23],
      :zone_25_pitches => player.zone_25_pitches + player.zone_pitches_thrown[24],
      :zone_26_pitches => player.zone_26_pitches + player.zone_pitches_thrown[25],
      :zone_27_pitches => player.zone_27_pitches + player.zone_pitches_thrown[26],
      :zone_28_pitches => player.zone_28_pitches + player.zone_pitches_thrown[27],
      :zone_29_pitches => player.zone_29_pitches + player.zone_pitches_thrown[28],
      :zone_30_pitches => player.zone_30_pitches + player.zone_pitches_thrown[29],
      :zone_31_pitches => player.zone_31_pitches + player.zone_pitches_thrown[30],
      :zone_32_pitches => player.zone_32_pitches + player.zone_pitches_thrown[31],
      :zone_33_pitches => player.zone_33_pitches + player.zone_pitches_thrown[32],
      :zone_34_pitches => player.zone_34_pitches + player.zone_pitches_thrown[33],
      :zone_35_pitches => player.zone_35_pitches + player.zone_pitches_thrown[34],
      :zone_36_pitches => player.zone_36_pitches + player.zone_pitches_thrown[35],
      :zone_37_pitches => player.zone_37_pitches + player.zone_pitches_thrown[36],
      :zone_38_pitches => player.zone_38_pitches + player.zone_pitches_thrown[37],
      :zone_39_pitches => player.zone_39_pitches + player.zone_pitches_thrown[38],
      :zone_40_pitches => player.zone_40_pitches + player.zone_pitches_thrown[39],
      :zone_41_pitches => player.zone_41_pitches + player.zone_pitches_thrown[40],
      :zone_42_pitches => player.zone_42_pitches + player.zone_pitches_thrown[41],
      :zone_43_pitches => player.zone_43_pitches + player.zone_pitches_thrown[42],
      :zone_44_pitches => player.zone_44_pitches + player.zone_pitches_thrown[43],
      :zone_45_pitches => player.zone_45_pitches + player.zone_pitches_thrown[44],
      :zone_46_pitches => player.zone_46_pitches + player.zone_pitches_thrown[45],
      :zone_47_pitches => player.zone_47_pitches + player.zone_pitches_thrown[46],
      :zone_48_pitches => player.zone_48_pitches + player.zone_pitches_thrown[47],
      :zone_49_pitches => player.zone_49_pitches + player.zone_pitches_thrown[48],
      :zone_50_pitches => player.zone_50_pitches + player.zone_pitches_thrown[49],
      :zone_51_pitches => player.zone_51_pitches + player.zone_pitches_thrown[50],
      :zone_52_pitches => player.zone_52_pitches + player.zone_pitches_thrown[51],
      :zone_53_pitches => player.zone_53_pitches + player.zone_pitches_thrown[52],
      :zone_54_pitches => player.zone_54_pitches + player.zone_pitches_thrown[53],
      :zone_55_pitches => player.zone_55_pitches + player.zone_pitches_thrown[54],
      :zone_56_pitches => player.zone_56_pitches + player.zone_pitches_thrown[55],
      :zone_57_pitches => player.zone_57_pitches + player.zone_pitches_thrown[56],
      :zone_58_pitches => player.zone_58_pitches + player.zone_pitches_thrown[57],
      :zone_59_pitches => player.zone_59_pitches + player.zone_pitches_thrown[58],
      :zone_60_pitches => player.zone_60_pitches + player.zone_pitches_thrown[59],
      :zone_61_pitches => player.zone_61_pitches + player.zone_pitches_thrown[60],
      :zone_62_pitches => player.zone_62_pitches + player.zone_pitches_thrown[61],
      :zone_63_pitches => player.zone_63_pitches + player.zone_pitches_thrown[62],
      :zone_64_pitches => player.zone_64_pitches + player.zone_pitches_thrown[63],
      :zone_65_pitches => player.zone_65_pitches + player.zone_pitches_thrown[64],
      :zone_66_pitches => player.zone_66_pitches + player.zone_pitches_thrown[65],
      :zone_67_pitches => player.zone_67_pitches + player.zone_pitches_thrown[66],
      :zone_68_pitches => player.zone_68_pitches + player.zone_pitches_thrown[67],
      :zone_69_pitches => player.zone_69_pitches + player.zone_pitches_thrown[68],
      :zone_70_pitches => player.zone_70_pitches + player.zone_pitches_thrown[69],
      :zone_71_pitches => player.zone_71_pitches + player.zone_pitches_thrown[70],
      :zone_72_pitches => player.zone_72_pitches + player.zone_pitches_thrown[71],
      :current_energy => player.game_current_energy)

    end

    # puts 'updating away pitcher stats'

    @away_team.game_pitcher_list.each do |player|

      player.errors_committed ||= 0
      player.assists ||= 0
      player.putouts ||= 0
      player.chances ||= 0
      player.outs_recorded ||= 0
      player.hits_allowed ||= 0
      player.runs_allowed ||= 0
      player.earned_runs_allowed ||= 0
      player.walks_allowed ||= 0
      player.strikeouts_recorded ||= 0
      player.home_runs_allowed ||= 0
      player.total_pitches ||= 0
      player.strikes_thrown ||= 0
      player.balls_thrown ||= 0
      player.intentional_walks_allowed ||= 0

      player.update_columns(:errors_committed => player.errors_committed + player.game_errors_committed,
      :assists => player.assists + player.game_assists,
      :putouts => player.putouts + player.game_putouts,
      :chances => player.chances + player.game_chances,
      :outs_recorded => player.outs_recorded + player.game_outs_recorded,
      :hits_allowed => player.hits_allowed + player.game_hits_allowed,
      :runs_allowed => player.runs_allowed + player.game_runs_allowed,
      :earned_runs_allowed => player.earned_runs_allowed + player.game_earned_runs_allowed,
      :walks_allowed => player.walks_allowed + player.game_walks_allowed,
      :strikeouts_recorded => player.strikeouts_recorded + player.game_strikeouts_recorded,
      :home_runs_allowed => player.home_runs_allowed + player.game_home_runs_allowed,
      :total_pitches => player.total_pitches + player.game_total_pitches,
      :strikes_thrown => player.strikes_thrown + player.game_strikes_thrown,
      :balls_thrown => player.balls_thrown + player.game_balls_thrown,
      :intentional_walks_allowed => player.intentional_walks_allowed + player.game_intentional_walks_allowed,
      :zone_1_pitches => player.zone_1_pitches + player.zone_pitches_thrown[0],
      :zone_2_pitches => player.zone_2_pitches + player.zone_pitches_thrown[1],
      :zone_3_pitches => player.zone_3_pitches + player.zone_pitches_thrown[2],
      :zone_4_pitches => player.zone_4_pitches + player.zone_pitches_thrown[3],
      :zone_5_pitches => player.zone_5_pitches + player.zone_pitches_thrown[4],
      :zone_6_pitches => player.zone_6_pitches + player.zone_pitches_thrown[5],
      :zone_7_pitches => player.zone_7_pitches + player.zone_pitches_thrown[6],
      :zone_8_pitches => player.zone_8_pitches + player.zone_pitches_thrown[7],
      :zone_9_pitches => player.zone_9_pitches + player.zone_pitches_thrown[8],
      :zone_10_pitches => player.zone_10_pitches + player.zone_pitches_thrown[9],
      :zone_11_pitches => player.zone_11_pitches + player.zone_pitches_thrown[10],
      :zone_12_pitches => player.zone_12_pitches + player.zone_pitches_thrown[11],
      :zone_13_pitches => player.zone_13_pitches + player.zone_pitches_thrown[12],
      :zone_14_pitches => player.zone_14_pitches + player.zone_pitches_thrown[13],
      :zone_15_pitches => player.zone_15_pitches + player.zone_pitches_thrown[14],
      :zone_16_pitches => player.zone_16_pitches + player.zone_pitches_thrown[15],
      :zone_17_pitches => player.zone_17_pitches + player.zone_pitches_thrown[16],
      :zone_18_pitches => player.zone_18_pitches + player.zone_pitches_thrown[17],
      :zone_19_pitches => player.zone_19_pitches + player.zone_pitches_thrown[18],
      :zone_20_pitches => player.zone_20_pitches + player.zone_pitches_thrown[19],
      :zone_21_pitches => player.zone_21_pitches + player.zone_pitches_thrown[20],
      :zone_22_pitches => player.zone_22_pitches + player.zone_pitches_thrown[21],
      :zone_23_pitches => player.zone_23_pitches + player.zone_pitches_thrown[22],
      :zone_24_pitches => player.zone_24_pitches + player.zone_pitches_thrown[23],
      :zone_25_pitches => player.zone_25_pitches + player.zone_pitches_thrown[24],
      :zone_26_pitches => player.zone_26_pitches + player.zone_pitches_thrown[25],
      :zone_27_pitches => player.zone_27_pitches + player.zone_pitches_thrown[26],
      :zone_28_pitches => player.zone_28_pitches + player.zone_pitches_thrown[27],
      :zone_29_pitches => player.zone_29_pitches + player.zone_pitches_thrown[28],
      :zone_30_pitches => player.zone_30_pitches + player.zone_pitches_thrown[29],
      :zone_31_pitches => player.zone_31_pitches + player.zone_pitches_thrown[30],
      :zone_32_pitches => player.zone_32_pitches + player.zone_pitches_thrown[31],
      :zone_33_pitches => player.zone_33_pitches + player.zone_pitches_thrown[32],
      :zone_34_pitches => player.zone_34_pitches + player.zone_pitches_thrown[33],
      :zone_35_pitches => player.zone_35_pitches + player.zone_pitches_thrown[34],
      :zone_36_pitches => player.zone_36_pitches + player.zone_pitches_thrown[35],
      :zone_37_pitches => player.zone_37_pitches + player.zone_pitches_thrown[36],
      :zone_38_pitches => player.zone_38_pitches + player.zone_pitches_thrown[37],
      :zone_39_pitches => player.zone_39_pitches + player.zone_pitches_thrown[38],
      :zone_40_pitches => player.zone_40_pitches + player.zone_pitches_thrown[39],
      :zone_41_pitches => player.zone_41_pitches + player.zone_pitches_thrown[40],
      :zone_42_pitches => player.zone_42_pitches + player.zone_pitches_thrown[41],
      :zone_43_pitches => player.zone_43_pitches + player.zone_pitches_thrown[42],
      :zone_44_pitches => player.zone_44_pitches + player.zone_pitches_thrown[43],
      :zone_45_pitches => player.zone_45_pitches + player.zone_pitches_thrown[44],
      :zone_46_pitches => player.zone_46_pitches + player.zone_pitches_thrown[45],
      :zone_47_pitches => player.zone_47_pitches + player.zone_pitches_thrown[46],
      :zone_48_pitches => player.zone_48_pitches + player.zone_pitches_thrown[47],
      :zone_49_pitches => player.zone_49_pitches + player.zone_pitches_thrown[48],
      :zone_50_pitches => player.zone_50_pitches + player.zone_pitches_thrown[49],
      :zone_51_pitches => player.zone_51_pitches + player.zone_pitches_thrown[50],
      :zone_52_pitches => player.zone_52_pitches + player.zone_pitches_thrown[51],
      :zone_53_pitches => player.zone_53_pitches + player.zone_pitches_thrown[52],
      :zone_54_pitches => player.zone_54_pitches + player.zone_pitches_thrown[53],
      :zone_55_pitches => player.zone_55_pitches + player.zone_pitches_thrown[54],
      :zone_56_pitches => player.zone_56_pitches + player.zone_pitches_thrown[55],
      :zone_57_pitches => player.zone_57_pitches + player.zone_pitches_thrown[56],
      :zone_58_pitches => player.zone_58_pitches + player.zone_pitches_thrown[57],
      :zone_59_pitches => player.zone_59_pitches + player.zone_pitches_thrown[58],
      :zone_60_pitches => player.zone_60_pitches + player.zone_pitches_thrown[59],
      :zone_61_pitches => player.zone_61_pitches + player.zone_pitches_thrown[60],
      :zone_62_pitches => player.zone_62_pitches + player.zone_pitches_thrown[61],
      :zone_63_pitches => player.zone_63_pitches + player.zone_pitches_thrown[62],
      :zone_64_pitches => player.zone_64_pitches + player.zone_pitches_thrown[63],
      :zone_65_pitches => player.zone_65_pitches + player.zone_pitches_thrown[64],
      :zone_66_pitches => player.zone_66_pitches + player.zone_pitches_thrown[65],
      :zone_67_pitches => player.zone_67_pitches + player.zone_pitches_thrown[66],
      :zone_68_pitches => player.zone_68_pitches + player.zone_pitches_thrown[67],
      :zone_69_pitches => player.zone_69_pitches + player.zone_pitches_thrown[68],
      :zone_70_pitches => player.zone_70_pitches + player.zone_pitches_thrown[69],
      :zone_71_pitches => player.zone_71_pitches + player.zone_pitches_thrown[70],
      :zone_72_pitches => player.zone_72_pitches + player.zone_pitches_thrown[71],
      :current_energy => player.game_current_energy)

    end

    # home batting stats
    home_at_bats_string = ""
    home_runs_scored_string = ""
    home_hits_string = ""
    home_doubles_string = ""
    home_triples_string = ""
    home_home_runs_string = ""
    home_RBI_string = ""
    home_walks_string = ""
    home_strikeouts_string = ""
    home_stolen_bases_string = ""
    home_caught_stealing_string = ""
    home_errors_string = ""
    home_assists_string = ""
    home_putouts_string = ""
    home_chances_string = ""

    # away batting stats
    away_at_bats_string = ""
    away_runs_scored_string = ""
    away_hits_string = ""
    away_doubles_string = ""
    away_triples_string = ""
    away_home_runs_string = ""
    away_RBI_string = ""
    away_walks_string = ""
    away_strikeouts_string = ""
    away_stolen_bases_string = ""
    away_caught_stealing_string = ""
    away_errors_string = ""
    away_assists_string = ""
    away_putouts_string = ""
    away_chances_string = ""

    # home pitching stats
    home_outs_recorded_string = []
    home_hits_allowed_string = []
    home_runs_allowed_string = []
    home_earned_runs_allowed_string = []
    home_walks_allowed_string = []
    home_strikeouts_recorded_string = []
    home_home_runs_allowed_string = []
    home_total_pitches_string = []
    home_strikes_thrown_string = []
    home_balls_thrown_string = []
    home_intentional_walks_allowed_string = []

    # away pitching stats
    away_outs_recorded_string = []
    away_hits_allowed_string = []
    away_runs_allowed_string = []
    away_earned_runs_allowed_string = []
    away_walks_allowed_string = []
    away_strikeouts_recorded_string = []
    away_home_runs_allowed_string = []
    away_total_pitches_string = []
    away_strikes_thrown_string = []
    away_balls_thrown_string = []
    away_intentional_walks_allowed_string = []

    # home pitching stats
    @home_team.game_pitcher_list.each do |pitcher|
      home_outs_recorded_string.push(pitcher.game_outs_recorded)
      home_hits_allowed_string.push(pitcher.game_hits_allowed)
      home_runs_allowed_string.push(pitcher.game_runs_allowed)
      home_earned_runs_allowed_string.push(pitcher.game_earned_runs_allowed)
      home_walks_allowed_string.push(pitcher.game_walks_allowed)
      home_strikeouts_recorded_string.push(pitcher.game_strikeouts_recorded)
      home_home_runs_allowed_string.push(pitcher.game_home_runs_allowed)
      home_total_pitches_string.push(pitcher.game_total_pitches)
      home_strikes_thrown_string.push(pitcher.game_strikes_thrown)
      home_balls_thrown_string.push(pitcher.game_balls_thrown)
      home_intentional_walks_allowed_string.push(pitcher.game_intentional_walks_allowed)
    end

    # away pitching stats
    @away_team.game_pitcher_list.each do |pitcher|
      away_outs_recorded_string.push(pitcher.game_outs_recorded)
      away_hits_allowed_string.push(pitcher.game_hits_allowed)
      away_runs_allowed_string.push(pitcher.game_runs_allowed)
      away_earned_runs_allowed_string.push(pitcher.game_earned_runs_allowed)
      away_walks_allowed_string.push(pitcher.game_walks_allowed)
      away_strikeouts_recorded_string.push(pitcher.game_strikeouts_recorded)
      away_home_runs_allowed_string.push(pitcher.game_home_runs_allowed)
      away_total_pitches_string.push(pitcher.game_total_pitches)
      away_strikes_thrown_string.push(pitcher.game_strikes_thrown)
      away_balls_thrown_string.push(pitcher.game_balls_thrown)
      away_intentional_walks_allowed_string.push(pitcher.game_intentional_walks_allowed)
    end

    for i in 0..8 do

      # home batting stats
      home_at_bats_string = home_at_bats_string + "#{@home_team.game_lineup_players[i].game_atbats}"
      home_runs_scored_string = home_runs_scored_string + "#{@home_team.game_lineup_players[i].game_runs_scored}"
      home_hits_string = home_hits_string + "#{@home_team.game_lineup_players[i].game_hits}"
      home_doubles_string = home_doubles_string + "#{@home_team.game_lineup_players[i].game_doubles}"
      home_triples_string = home_triples_string + "#{@home_team.game_lineup_players[i].game_triples}"
      home_home_runs_string = home_home_runs_string + "#{@home_team.game_lineup_players[i].game_home_runs}"
      home_RBI_string = home_RBI_string + "#{@home_team.game_lineup_players[i].game_rbi}"
      home_walks_string = home_walks_string + "#{@home_team.game_lineup_players[i].game_walks}"
      home_strikeouts_string = home_strikeouts_string + "#{@home_team.game_lineup_players[i].game_strikeouts}"
      home_stolen_bases_string = home_stolen_bases_string + "#{@home_team.game_lineup_players[i].game_stolen_bases}"
      home_caught_stealing_string = home_caught_stealing_string + "#{@home_team.game_lineup_players[i].game_caught_stealing}"
      home_errors_string = home_errors_string + "#{@home_team.game_lineup_players[i].game_errors_committed}"
      home_assists_string = home_assists_string + "#{@home_team.game_lineup_players[i].game_assists}"
      home_putouts_string = home_putouts_string + "#{@home_team.game_lineup_players[i].game_putouts}"
      home_chances_string = home_chances_string + "#{@home_team.game_lineup_players[i].game_chances}"

      # away batting stats
      away_at_bats_string = away_at_bats_string + "#{@away_team.game_lineup_players[i].game_atbats}"
      away_runs_scored_string = away_runs_scored_string + "#{@away_team.game_lineup_players[i].game_runs_scored}"
      away_hits_string = away_hits_string + "#{@away_team.game_lineup_players[i].game_hits}"
      away_doubles_string = away_doubles_string + "#{@away_team.game_lineup_players[i].game_doubles}"
      away_triples_string = away_triples_string + "#{@away_team.game_lineup_players[i].game_triples}"
      away_home_runs_string = away_home_runs_string + "#{@away_team.game_lineup_players[i].game_home_runs}"
      away_RBI_string = away_RBI_string + "#{@away_team.game_lineup_players[i].game_rbi}"
      away_walks_string = away_walks_string + "#{@away_team.game_lineup_players[i].game_walks}"
      away_strikeouts_string = away_strikeouts_string + "#{@away_team.game_lineup_players[i].game_strikeouts}"
      away_stolen_bases_string = away_stolen_bases_string + "#{@away_team.game_lineup_players[i].game_stolen_bases}"
      away_caught_stealing_string = away_caught_stealing_string + "#{@away_team.game_lineup_players[i].game_caught_stealing}"
      away_errors_string = away_errors_string + "#{@away_team.game_lineup_players[i].game_errors_committed}"
      away_assists_string = away_assists_string + "#{@away_team.game_lineup_players[i].game_assists}"
      away_putouts_string = away_putouts_string + "#{@away_team.game_lineup_players[i].game_putouts}"
      away_chances_string = away_chances_string + "#{@away_team.game_lineup_players[i].game_chances}"

      if i < 8
        # home batting stats
        home_at_bats_string = home_at_bats_string + "_"
        home_runs_scored_string = home_runs_scored_string + "_"
        home_hits_string = home_hits_string + "_"
        home_doubles_string = home_doubles_string + "_"
        home_triples_string = home_triples_string + "_"
        home_home_runs_string = home_home_runs_string + "_"
        home_RBI_string = home_RBI_string + "_"
        home_walks_string = home_walks_string + "_"
        home_strikeouts_string = home_strikeouts_string + "_"
        home_stolen_bases_string = home_stolen_bases_string + "_"
        home_caught_stealing_string = home_caught_stealing_string + "_"
        home_errors_string = home_errors_string + "_"
        home_assists_string = home_assists_string + "_"
        home_putouts_string = home_putouts_string + "_"
        home_chances_string = home_chances_string + "_"

        # away batting stats
        away_at_bats_string = away_at_bats_string + "_"
        away_runs_scored_string = away_runs_scored_string + "_"
        away_hits_string = away_hits_string + "_"
        away_doubles_string = away_doubles_string + "_"
        away_triples_string = away_triples_string + "_"
        away_home_runs_string = away_home_runs_string + "_"
        away_RBI_string = away_RBI_string + "_"
        away_walks_string = away_walks_string + "_"
        away_strikeouts_string = away_strikeouts_string + "_"
        away_stolen_bases_string = away_stolen_bases_string + "_"
        away_caught_stealing_string = away_caught_stealing_string + "_"
        away_errors_string = away_errors_string + "_"
        away_assists_string = away_assists_string + "_"
        away_putouts_string = away_putouts_string + "_"
        away_chances_string = away_chances_string + "_"
      end
    end

    # runs scored in each inning
    away_inning_scores = @away_team.game_inning_scores.chop
    home_inning_scores = @home_team.game_inning_scores.chop

    # home batting stats
    home_atbats = home_at_bats_string
    home_runs_scored = home_runs_scored_string
    home_hits = home_hits_string
    home_doubles = home_doubles_string
    home_triples = home_triples_string
    home_home_runs = home_home_runs_string
    home_RBI = home_RBI_string
    home_walks = home_walks_string
    home_strikeouts = home_strikeouts_string
    home_stolen_bases = home_stolen_bases_string
    home_caught_stealing = home_caught_stealing_string
    home_errors = home_errors_string
    home_assists = home_assists_string
    home_putouts = home_putouts_string
    home_chances = home_chances_string

    # away batting stats
    away_atbats = away_at_bats_string
    away_runs_scored = away_runs_scored_string
    away_hits = away_hits_string
    away_doubles = away_doubles_string
    away_triples = away_triples_string
    away_home_runs = away_home_runs_string
    away_RBI = away_RBI_string
    away_walks = away_walks_string
    away_strikeouts = away_strikeouts_string
    away_stolen_bases = away_stolen_bases_string
    away_caught_stealing = away_caught_stealing_string
    away_errors = away_errors_string
    away_assists = away_assists_string
    away_putouts = away_putouts_string
    away_chances = away_chances_string

    # away pitching stats
    away_outs_recorded = away_outs_recorded_string.join("_")
    away_hits_allowed = away_hits_allowed_string.join("_")
    away_runs_allowed = away_runs_allowed_string.join("_")
    away_earned_runs_allowed = away_earned_runs_allowed_string.join("_")
    away_walks_allowed = away_walks_allowed_string.join("_")
    away_strikeouts_recorded = away_strikeouts_recorded_string.join("_")
    away_home_runs_allowed = away_home_runs_allowed_string.join("_")
    away_total_pitches = away_total_pitches_string.join("_")
    away_strikes_thrown = away_strikes_thrown_string.join("_")
    away_balls_thrown = away_balls_thrown_string.join("_")
    away_intentional_walks_allowed = away_intentional_walks_allowed_string.join("_")

    # home pitching stats
    home_outs_recorded = home_outs_recorded_string.join("_")
    home_hits_allowed = home_hits_allowed_string.join("_")
    home_runs_allowed = home_runs_allowed_string.join("_")
    home_earned_runs_allowed = home_earned_runs_allowed_string.join("_")
    home_walks_allowed = home_walks_allowed_string.join("_")
    home_strikeouts_recorded = home_strikeouts_recorded_string.join("_")
    home_home_runs_allowed = home_home_runs_allowed_string.join("_")
    home_total_pitches = home_total_pitches_string.join("_")
    home_strikes_thrown = home_strikes_thrown_string.join("_")
    home_balls_thrown = home_balls_thrown_string.join("_")
    home_intentional_walks_allowed = home_intentional_walks_allowed_string.join("_")

    # play by play
    pbp = @play_by_play

    # game number (needs to be changed from first to the current season when there are more than 1 seasons)

    # update pitcher list
    home_pitchers = @home_team.game_pitcher_list.map { |pitcher| pitcher.id }.join("_")
    away_pitchers = @away_team.game_pitcher_list.map { |pitcher| pitcher.id }.join("_")

    # puts 'updating game stats'

    # Game attributes
    update_attributes(:attendance => @home_team.capacity,
    :stadium_name => @home_team.stadium,
    :home_lineup => @home_team.game_lineup,
    :away_lineup => @away_team.game_lineup,
    :home_atbats => home_atbats,
    :home_runs_scored => home_runs_scored,
    :home_hits => home_hits,
    :home_doubles => home_doubles,
    :home_triples => home_triples,
    :home_home_runs => home_home_runs,
    :home_RBI => home_RBI,
    :home_walks => home_walks,
    :home_strikeouts => home_strikeouts,
    :home_stolen_bases => home_stolen_bases,
    :home_caught_stealing => home_caught_stealing,
    :home_errors => home_errors,
    :home_assists => home_assists,
    :home_putouts => home_putouts,
    :home_chances => home_chances,
    :away_atbats => away_atbats,
    :away_runs_scored => away_runs_scored,
    :away_hits => away_hits,
    :away_doubles => away_doubles,
    :away_triples => away_triples,
    :away_home_runs => away_home_runs,
    :away_RBI => away_RBI,
    :away_walks => away_walks,
    :away_strikeouts => away_strikeouts,
    :away_stolen_bases => away_stolen_bases,
    :away_caught_stealing => away_caught_stealing,
    :away_errors => away_errors,
    :away_assists => away_assists,
    :away_putouts => away_putouts,
    :away_chances => away_chances,
    :home_pitchers => home_pitchers,
    :away_pitchers => away_pitchers,
    :home_outs_recorded => home_outs_recorded,
    :home_hits_allowed => home_hits_allowed,
    :home_runs_allowed => home_runs_allowed,
    :home_earned_runs_allowed => home_earned_runs_allowed,
    :home_walks_allowed => home_walks_allowed,
    :home_strikeouts_recorded => home_strikeouts_recorded,
    :home_home_runs_allowed => home_home_runs_allowed,
    :home_total_pitches => home_total_pitches,
    :home_strikes_thrown => home_strikes_thrown,
    :home_balls_thrown => home_balls_thrown,
    :home_intentional_walks_allowed => home_intentional_walks_allowed,
    :away_outs_recorded => away_outs_recorded,
    :away_hits_allowed => away_hits_allowed,
    :away_runs_allowed => away_runs_allowed,
    :away_earned_runs_allowed => away_earned_runs_allowed,
    :away_walks_allowed => away_walks_allowed,
    :away_strikeouts_recorded => away_strikeouts_recorded,
    :away_home_runs_allowed => away_home_runs_allowed,
    :away_total_pitches => away_total_pitches,
    :away_strikes_thrown => away_strikes_thrown,
    :away_balls_thrown => away_balls_thrown,
    :away_intentional_walks_allowed => away_intentional_walks_allowed,
    :player_of_the_game => nil,
    :home_inning_scores => @home_team.game_inning_scores,
    :away_inning_scores => @away_team.game_inning_scores,
    :pbp => "play_by_play", # TODO: change this back to play_by_play
    :season_id => @season_id,
    :game_number => @game_number,
    :winning_pitcher => winning_pitcher,
    :losing_pitcher => losing_pitcher,
    :sim_date => @game_date)

  end

end
