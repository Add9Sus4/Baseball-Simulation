# If we access the database every time we want to reference a heat map value,
# then a game takes roughly 90 seconds to simulate.
# If we load the heat maps first and then simulate the game, the total duration
# is 65 seconds. Since loading the heat maps takes roughly 60 seconds, the game
# simulation only takes 5 seconds to complete with the heat maps loaded into
# memory. Therefore, game simulation runs almost 20 times faster if all the
# heat maps are loaded into a hash before the game begins
class Game < ActiveRecord::Base
  validate :teams_must_be_different
  attr_accessor :pbp, :bad, :good, :home_team, :away_team, :inning_status, :inning_number, :away_team_lineup_position, :home_team_lineup_position, :away_team_score, :home_team_score, :home_team_inning_scores, :away_team_inning_scores, :over

  def teams_must_be_different
    errors.add(:base, "Teams cannot be the same") if home_team_id == away_team_id
  end

  # Plays a game
  def play
    prepare

    # Simulate game
    while !@over do
      # Top of inning
      unless @inning_number == 1 && @inning_status == InningStatus::TOP
        @pbp += "\n____________________________________________________________________________\n"
      end
      @pbp += "\n<h4><strong>Top of inning #{@inning_number} (#{@away_team.full_name} batting):</strong></h4>\n"
      @inning_status = InningStatus::TOP
      inning = Inning.new(self)
      # Bottom of inning
      if @inning_number == 9 && @home_team_score > @away_team_score
        @over = true
      end
      @pbp += "\n____________________________________________________________________________\n"
      @pbp += "\n<h4><strong>Bottom of inning #{@inning_number} (#{@home_team.full_name} batting):</strong></h4>\n"
      @inning_status = InningStatus::BOTTOM
      inning = Inning.new(self)
      if @inning_number > 8 && @home_team_score != @away_team_score
        @over = true
      end
      @inning_number = @inning_number + 1
    end # game is over here

    collect_stats
  end

  def collect_stats

    # team win/loss stats
    # Home team wins
    if @home_team_score > @away_team_score
      @home_team.update_attribute(:wins, @home_team.wins + 1)
      @away_team.update_attribute(:losses, @away_team.losses + 1)

      # Home team streak
      @home_team.streak >= 0 ? @home_team.update_attribute(:streak, @home_team.streak + 1) : @home_team.update_attribute(:streak, 1)

      # Away team streak
      @away_team.streak <= 0 ? @away_team.update_attribute(:streak, @away_team.streak - 1) : @away_team.update_attribute(:streak, -1)

    # Away team wins
    else
      @home_team.update_attribute(:losses, @home_team.losses + 1)
      @away_team.update_attribute(:wins, @away_team.wins + 1)

      # Home team streak
      @home_team.streak <= 0 ? @home_team.update_attribute(:streak, @home_team.streak - 1) : @home_team.update_attribute(:streak, -1)

      # Away team streak
      @away_team.streak >= 0 ? @away_team.update_attribute(:streak, @away_team.streak + 1) : @away_team.update_attribute(:streak, 1)

    end

    # team runs scored and allowed
    @home_team.update_attribute(:runs_scored, @home_team.runs_scored + @home_team_score)
    @away_team.update_attribute(:runs_scored, @away_team.runs_scored + @away_team_score)
    @home_team.update_attribute(:runs_allowed, @home_team.runs_allowed + @away_team_score)
    @away_team.update_attribute(:runs_allowed, @away_team.runs_allowed + @home_team_score)

    # player stats
    @home_team.players.each do |player|
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

      player.update_attribute(:atbats, player.atbats + player.game_atbats)
      player.update_attribute(:runs, player.runs + player.game_runs_scored)
      player.update_attribute(:hits, player.hits + player.game_hits)
      player.update_attribute(:doubles, player.doubles + player.game_doubles)
      player.update_attribute(:triples, player.triples + player.game_triples)
      player.update_attribute(:home_runs, player.home_runs + player.game_home_runs)
      player.update_attribute(:rbi, player.rbi + player.game_rbi)
      player.update_attribute(:walks, player.walks + player.game_walks)
      player.update_attribute(:strikeouts, player.strikeouts + player.game_strikeouts)
      player.update_attribute(:stolen_bases, player.stolen_bases + player.game_stolen_bases)
      player.update_attribute(:caught_stealing, player.caught_stealing + player.game_caught_stealing)
      player.update_attribute(:errors_committed, player.errors_committed + player.game_errors_committed)
      player.update_attribute(:assists, player.assists + player.game_assists)
      player.update_attribute(:putouts, player.putouts + player.game_putouts)
      player.update_attribute(:chances, player.chances + player.game_chances)
      player.update_attribute(:outs_recorded, player.outs_recorded + player.game_outs_recorded)
      player.update_attribute(:hits_allowed, player.hits_allowed + player.game_hits_allowed)
      player.update_attribute(:runs_allowed, player.runs_allowed + player.game_runs_allowed)
      player.update_attribute(:earned_runs_allowed, player.earned_runs_allowed + player.game_earned_runs_allowed)
      player.update_attribute(:walks_allowed, player.walks_allowed + player.game_walks_allowed)
      player.update_attribute(:strikeouts_recorded, player.strikeouts_recorded + player.game_strikeouts_recorded)
      player.update_attribute(:home_runs_allowed, player.home_runs_allowed + player.game_home_runs_allowed)
      player.update_attribute(:total_pitches, player.total_pitches + player.game_total_pitches)
      player.update_attribute(:strikes_thrown, player.strikes_thrown + player.game_strikes_thrown)
      player.update_attribute(:balls_thrown, player.balls_thrown + player.game_balls_thrown)
      player.update_attribute(:intentional_walks_allowed, player.intentional_walks_allowed + player.game_intentional_walks_allowed)
      for i in 1..72 do
        player.update_attribute("zone_#{i}_pitches".to_sym, player["zone_#{i}_pitches".to_sym] + player.zone_pitches_thrown[i-1])
      end
    end

    @away_team.players.each do |player|

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

      player.update_attribute(:atbats, player.atbats + player.game_atbats)
      player.update_attribute(:runs, player.runs + player.game_runs_scored)
      player.update_attribute(:hits, player.hits + player.game_hits)
      player.update_attribute(:doubles, player.doubles + player.game_doubles)
      player.update_attribute(:triples, player.triples + player.game_triples)
      player.update_attribute(:home_runs, player.home_runs + player.game_home_runs)
      player.update_attribute(:rbi, player.rbi + player.game_rbi)
      player.update_attribute(:walks, player.walks + player.game_walks)
      player.update_attribute(:strikeouts, player.strikeouts + player.game_strikeouts)
      player.update_attribute(:stolen_bases, player.stolen_bases + player.game_stolen_bases)
      player.update_attribute(:caught_stealing, player.caught_stealing + player.game_caught_stealing)
      player.update_attribute(:errors_committed, player.errors_committed + player.game_errors_committed)
      player.update_attribute(:assists, player.assists + player.game_assists)
      player.update_attribute(:putouts, player.putouts + player.game_putouts)
      player.update_attribute(:chances, player.chances + player.game_chances)
      player.update_attribute(:outs_recorded, player.outs_recorded + player.game_outs_recorded)
      player.update_attribute(:hits_allowed, player.hits_allowed + player.game_hits_allowed)
      player.update_attribute(:runs_allowed, player.runs_allowed + player.game_runs_allowed)
      player.update_attribute(:earned_runs_allowed, player.earned_runs_allowed + player.game_earned_runs_allowed)
      player.update_attribute(:walks_allowed, player.walks_allowed + player.game_walks_allowed)
      player.update_attribute(:strikeouts_recorded, player.strikeouts_recorded + player.game_strikeouts_recorded)
      player.update_attribute(:home_runs_allowed, player.home_runs_allowed + player.game_home_runs_allowed)
      player.update_attribute(:total_pitches, player.total_pitches + player.game_total_pitches)
      player.update_attribute(:strikes_thrown, player.strikes_thrown + player.game_strikes_thrown)
      player.update_attribute(:balls_thrown, player.balls_thrown + player.game_balls_thrown)
      player.update_attribute(:intentional_walks_allowed, player.intentional_walks_allowed + player.game_intentional_walks_allowed)
      for i in 1..72 do
        player.update_attribute("zone_#{i}_pitches".to_sym, player["zone_#{i}_pitches".to_sym] + player.zone_pitches_thrown[i-1])
      end
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
    home_outs_recorded_string = ""
    home_hits_allowed_string = ""
    home_runs_allowed_string = ""
    home_earned_runs_allowed_string = ""
    home_walks_allowed_string = ""
    home_strikeouts_recorded_string = ""
    home_home_runs_allowed_string = ""
    home_total_pitches_string = ""
    home_strikes_thrown_string = ""
    home_balls_thrown_string = ""
    home_intentional_walks_allowed_string = ""

    # away pitching stats
    away_outs_recorded_string = ""
    away_hits_allowed_string = ""
    away_runs_allowed_string = ""
    away_earned_runs_allowed_string = ""
    away_walks_allowed_string = ""
    away_strikeouts_recorded_string = ""
    away_home_runs_allowed_string = ""
    away_total_pitches_string = ""
    away_strikes_thrown_string = ""
    away_balls_thrown_string = ""
    away_intentional_walks_allowed_string = ""

    for i in 0..8 do

      # home batting stats
      home_at_bats_string = home_at_bats_string + "#{@home_team.find_player_by_lineup_index(i).game_atbats}"
      home_runs_scored_string = home_runs_scored_string + "#{@home_team.find_player_by_lineup_index(i).game_runs_scored}"
      home_hits_string = home_hits_string + "#{@home_team.find_player_by_lineup_index(i).game_hits}"
      home_doubles_string = home_doubles_string + "#{@home_team.find_player_by_lineup_index(i).game_doubles}"
      home_triples_string = home_triples_string + "#{@home_team.find_player_by_lineup_index(i).game_triples}"
      home_home_runs_string = home_home_runs_string + "#{@home_team.find_player_by_lineup_index(i).game_home_runs}"
      home_RBI_string = home_RBI_string + "#{@home_team.find_player_by_lineup_index(i).game_rbi}"
      home_walks_string = home_walks_string + "#{@home_team.find_player_by_lineup_index(i).game_walks}"
      home_strikeouts_string = home_strikeouts_string + "#{@home_team.find_player_by_lineup_index(i).game_strikeouts}"
      home_stolen_bases_string = home_stolen_bases_string + "#{@home_team.find_player_by_lineup_index(i).game_stolen_bases}"
      home_caught_stealing_string = home_caught_stealing_string + "#{@home_team.find_player_by_lineup_index(i).game_caught_stealing}"
      home_errors_string = home_errors_string + "#{@home_team.find_player_by_lineup_index(i).game_errors_committed}"
      home_assists_string = home_assists_string + "#{@home_team.find_player_by_lineup_index(i).game_assists}"
      home_putouts_string = home_putouts_string + "#{@home_team.find_player_by_lineup_index(i).game_putouts}"
      home_chances_string = home_chances_string + "#{@home_team.find_player_by_lineup_index(i).game_chances}"

      # away batting stats
      away_at_bats_string = away_at_bats_string + "#{@away_team.find_player_by_lineup_index(i).game_atbats}"
      away_runs_scored_string = away_runs_scored_string + "#{@away_team.find_player_by_lineup_index(i).game_runs_scored}"
      away_hits_string = away_hits_string + "#{@away_team.find_player_by_lineup_index(i).game_hits}"
      away_doubles_string = away_doubles_string + "#{@away_team.find_player_by_lineup_index(i).game_doubles}"
      away_triples_string = away_triples_string + "#{@away_team.find_player_by_lineup_index(i).game_triples}"
      away_home_runs_string = away_home_runs_string + "#{@away_team.find_player_by_lineup_index(i).game_home_runs}"
      away_RBI_string = away_RBI_string + "#{@away_team.find_player_by_lineup_index(i).game_rbi}"
      away_walks_string = away_walks_string + "#{@away_team.find_player_by_lineup_index(i).game_walks}"
      away_strikeouts_string = away_strikeouts_string + "#{@away_team.find_player_by_lineup_index(i).game_strikeouts}"
      away_stolen_bases_string = away_stolen_bases_string + "#{@away_team.find_player_by_lineup_index(i).game_stolen_bases}"
      away_caught_stealing_string = away_caught_stealing_string + "#{@away_team.find_player_by_lineup_index(i).game_caught_stealing}"
      away_errors_string = away_errors_string + "#{@away_team.find_player_by_lineup_index(i).game_errors_committed}"
      away_assists_string = away_assists_string + "#{@away_team.find_player_by_lineup_index(i).game_assists}"
      away_putouts_string = away_putouts_string + "#{@away_team.find_player_by_lineup_index(i).game_putouts}"
      away_chances_string = away_chances_string + "#{@away_team.find_player_by_lineup_index(i).game_chances}"

      # home pitching stats
      home_outs_recorded_string = home_outs_recorded_string + "#{@home_team.find_player_by_lineup_index(i).game_outs_recorded}"
      home_hits_allowed_string = home_hits_allowed_string + "#{@home_team.find_player_by_lineup_index(i).game_hits_allowed}"
      home_runs_allowed_string = home_runs_allowed_string + "#{@home_team.find_player_by_lineup_index(i).game_runs_allowed}"
      home_earned_runs_allowed_string = home_earned_runs_allowed_string + "#{@home_team.find_player_by_lineup_index(i).game_earned_runs_allowed}"
      home_walks_allowed_string = home_walks_allowed_string + "#{@home_team.find_player_by_lineup_index(i).game_walks_allowed}"
      home_strikeouts_recorded_string = home_strikeouts_recorded_string + "#{@home_team.find_player_by_lineup_index(i).game_strikeouts_recorded}"
      home_home_runs_allowed_string = home_home_runs_allowed_string + "#{@home_team.find_player_by_lineup_index(i).game_home_runs_allowed}"
      home_total_pitches_string = home_total_pitches_string + "#{@home_team.find_player_by_lineup_index(i).game_total_pitches}"
      home_strikes_thrown_string = home_strikes_thrown_string + "#{@home_team.find_player_by_lineup_index(i).game_strikes_thrown}"
      home_balls_thrown_string = home_balls_thrown_string + "#{@home_team.find_player_by_lineup_index(i).game_balls_thrown}"
      home_intentional_walks_allowed_string = home_intentional_walks_allowed_string + "#{@home_team.find_player_by_lineup_index(i).game_intentional_walks_allowed}"

      # away pitching stats
      away_outs_recorded_string = away_outs_recorded_string + "#{@away_team.find_player_by_lineup_index(i).game_outs_recorded}"
      away_hits_allowed_string = away_hits_allowed_string + "#{@away_team.find_player_by_lineup_index(i).game_hits_allowed}"
      away_runs_allowed_string = away_runs_allowed_string + "#{@away_team.find_player_by_lineup_index(i).game_runs_allowed}"
      away_earned_runs_allowed_string = away_earned_runs_allowed_string + "#{@away_team.find_player_by_lineup_index(i).game_earned_runs_allowed}"
      away_walks_allowed_string = away_walks_allowed_string + "#{@away_team.find_player_by_lineup_index(i).game_walks_allowed}"
      away_strikeouts_recorded_string = away_strikeouts_recorded_string + "#{@away_team.find_player_by_lineup_index(i).game_strikeouts_recorded}"
      away_home_runs_allowed_string = away_home_runs_allowed_string + "#{@away_team.find_player_by_lineup_index(i).game_home_runs_allowed}"
      away_total_pitches_string = away_total_pitches_string + "#{@away_team.find_player_by_lineup_index(i).game_total_pitches}"
      away_strikes_thrown_string = away_strikes_thrown_string + "#{@away_team.find_player_by_lineup_index(i).game_strikes_thrown}"
      away_balls_thrown_string = away_balls_thrown_string + "#{@away_team.find_player_by_lineup_index(i).game_balls_thrown}"
      away_intentional_walks_allowed_string = away_intentional_walks_allowed_string + "#{@away_team.find_player_by_lineup_index(i).game_intentional_walks_allowed}"

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

        # home pitching stats
        home_outs_recorded_string = home_outs_recorded_string + "_"
        home_hits_allowed_string = home_hits_allowed_string + "_"
        home_runs_allowed_string = home_runs_allowed_string + "_"
        home_earned_runs_allowed_string = home_earned_runs_allowed_string + "_"
        home_walks_allowed_string = home_walks_allowed_string + "_"
        home_strikeouts_recorded_string = home_strikeouts_recorded_string + "_"
        home_home_runs_allowed_string = home_home_runs_allowed_string + "_"
        home_total_pitches_string = home_total_pitches_string + "_"
        home_strikes_thrown_string = home_strikes_thrown_string + "_"
        home_balls_thrown_string = home_balls_thrown_string + "_"
        home_intentional_walks_allowed_string = home_intentional_walks_allowed_string + "_"

        # away pitching stats
        away_outs_recorded_string = away_outs_recorded_string + "_"
        away_hits_allowed_string = away_hits_allowed_string + "_"
        away_runs_allowed_string = away_runs_allowed_string + "_"
        away_earned_runs_allowed_string = away_earned_runs_allowed_string + "_"
        away_walks_allowed_string = away_walks_allowed_string + "_"
        away_strikeouts_recorded_string = away_strikeouts_recorded_string + "_"
        away_home_runs_allowed_string = away_home_runs_allowed_string + "_"
        away_total_pitches_string = away_total_pitches_string + "_"
        away_strikes_thrown_string = away_strikes_thrown_string + "_"
        away_balls_thrown_string = away_balls_thrown_string + "_"
        away_intentional_walks_allowed_string = away_intentional_walks_allowed_string + "_"
      end
    end

    # runs scored in each inning
    self.update_attributes(away_inning_scores: @away_team_inning_scores.chop)
    self.update_attributes(home_inning_scores: @home_team_inning_scores.chop)

    # home batting stats
    self.update_attributes(home_atbats: home_at_bats_string)
    self.update_attributes(home_runs_scored: home_runs_scored_string)
    self.update_attributes(home_hits: home_hits_string)
    self.update_attributes(home_doubles: home_doubles_string)
    self.update_attributes(home_triples: home_triples_string)
    self.update_attributes(home_home_runs: home_home_runs_string)
    self.update_attributes(home_RBI: home_RBI_string)
    self.update_attributes(home_walks: home_walks_string)
    self.update_attributes(home_strikeouts: home_strikeouts_string)
    self.update_attributes(home_stolen_bases: home_stolen_bases_string)
    self.update_attributes(home_caught_stealing: home_caught_stealing_string)
    self.update_attributes(home_errors: home_errors_string)
    self.update_attributes(home_assists: home_assists_string)
    self.update_attributes(home_putouts: home_putouts_string)
    self.update_attributes(home_chances: home_chances_string)

    # away batting stats
    self.update_attributes(away_atbats: away_at_bats_string)
    self.update_attributes(away_runs_scored: away_runs_scored_string)
    self.update_attributes(away_hits: away_hits_string)
    self.update_attributes(away_doubles: away_doubles_string)
    self.update_attributes(away_triples: away_triples_string)
    self.update_attributes(away_home_runs: away_home_runs_string)
    self.update_attributes(away_RBI: away_RBI_string)
    self.update_attributes(away_walks: away_walks_string)
    self.update_attributes(away_strikeouts: away_strikeouts_string)
    self.update_attributes(away_stolen_bases: away_stolen_bases_string)
    self.update_attributes(away_caught_stealing: away_caught_stealing_string)
    self.update_attributes(away_errors: away_errors_string)
    self.update_attributes(away_assists: away_assists_string)
    self.update_attributes(away_putouts: away_putouts_string)
    self.update_attributes(away_chances: away_chances_string)

    # away pitching stats
    self.update_attributes(away_outs_recorded: away_outs_recorded_string)
    self.update_attributes(away_hits_allowed: away_hits_allowed_string)
    self.update_attributes(away_runs_allowed: away_runs_allowed_string)
    self.update_attributes(away_earned_runs_allowed: away_earned_runs_allowed_string)
    self.update_attributes(away_walks_allowed: away_walks_allowed_string)
    self.update_attributes(away_strikeouts_recorded: away_strikeouts_recorded_string)
    self.update_attributes(away_home_runs_allowed: away_home_runs_allowed_string)
    self.update_attributes(away_total_pitches: away_total_pitches_string)
    self.update_attributes(away_strikes_thrown: away_strikes_thrown_string)
    self.update_attributes(away_balls_thrown: away_balls_thrown_string)
    self.update_attributes(away_intentional_walks_allowed: away_intentional_walks_allowed_string)

    # home pitching stats
    self.update_attributes(home_outs_recorded: home_outs_recorded_string)
    self.update_attributes(home_hits_allowed: home_hits_allowed_string)
    self.update_attributes(home_runs_allowed: home_runs_allowed_string)
    self.update_attributes(home_earned_runs_allowed: home_earned_runs_allowed_string)
    self.update_attributes(home_walks_allowed: home_walks_allowed_string)
    self.update_attributes(home_strikeouts_recorded: home_strikeouts_recorded_string)
    self.update_attributes(home_home_runs_allowed: home_home_runs_allowed_string)
    self.update_attributes(home_total_pitches: home_total_pitches_string)
    self.update_attributes(home_strikes_thrown: home_strikes_thrown_string)
    self.update_attributes(home_balls_thrown: home_balls_thrown_string)
    self.update_attributes(home_intentional_walks_allowed: home_intentional_walks_allowed_string)

    # play by play
    puts "updating pbp"
    puts "#{@pbp}"
    self.update_attributes(pbp: @pbp)
    puts "updating pbp done"

    # game number (needs to be changed from first to the current season when there are more than 1 seasons)
    self.update_attributes(game_number: Season.first.next_game)
    self.update_attributes(season_id: Season.first.id)
  end

  # Creates instance variables to use in the game
  def prepare

    @over = false
    @inning_number = 1
    @inning_status = InningStatus::TOP
    @home_team_lineup_position = 0
    @away_team_lineup_position = 0
    @home_team_score = 0
    @away_team_score = 0
    @home_team_inning_scores = ""
    @away_team_inning_scores = ""
    @pbp = ""
    @good = "#267373"
    @bad = "#854747"

    # home and away teams
    @home_team = Team.find(self.home_team_id)
    @away_team = Team.find(self.away_team_id)

    # put players on home team
    @home_team.players.each do |player|
      player.set_initial_stats
    end

    # put players on away team
    @away_team.players.each do |player|
      player.set_initial_stats
    end

    # stadium data
    self.stadium_name = @home_team.stadium
    self.attendance = rand(30000..60000)

    # lineups
    home_lineup_string = ""
    away_lineup_string = ""
    for i in 0..8 do
      home_lineup_string = home_lineup_string + "#{@home_team.find_player_by_lineup_index(i).id}"
      away_lineup_string = away_lineup_string + "#{@away_team.find_player_by_lineup_index(i).id}"
      if i < 8
        home_lineup_string = home_lineup_string + "_"
        away_lineup_string = away_lineup_string + "_"
      end
    end
    self.update_attributes(home_lineup: home_lineup_string)
    self.update_attributes(away_lineup: away_lineup_string)

  end

end
