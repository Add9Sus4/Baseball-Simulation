class Player < ActiveRecord::Base
  attr_accessor :zone_pitches_thrown, :game_atbats, :game_runs_scored, :game_hits, :game_doubles, :game_triples, :game_home_runs, :game_rbi, :game_walks, :game_strikeouts, :game_stolen_bases, :game_caught_stealing, :game_errors_committed, :game_assists, :game_putouts, :game_chances, :game_outs_recorded, :game_hits_allowed, :game_runs_allowed, :game_earned_runs_allowed, :game_walks_allowed, :game_strikeouts_recorded, :game_home_runs_allowed, :game_total_pitches, :game_strikes_thrown, :game_balls_thrown, :game_intentional_walks_allowed


  validates :team, :first_name, :last_name, :age, :height, :weight, :position, :salary, presence: true
  validates_numericality_of :weight, greater_than_or_equal_to: 160, less_than_or_equal_to: 300
  validate :team_cannot_have_more_than_max_players
  belongs_to :team


  def team_cannot_have_more_than_max_players
    team = Team.find(team_id);
    totalPlayers = team.players.length

    if totalPlayers >= Team::MAX_PLAYERS
      errors.add(:base, "The " + team.city + " " + team.name + " already have the maximum number of players allowed(" + Team::MAX_PLAYERS.to_s + ").")
    end
  end

  def pitches
    str = "#{pitch_name(pitch_1)}, #{pitch_name(pitch_2)}"
    if pitch_3 != "--" then str += ", #{pitch_name(pitch_3)}" end
    if pitch_4 != "--" then str += ", #{pitch_name(pitch_4)}" end
    if pitch_5 != "--" then str += ", #{pitch_name(pitch_5)}" end
    str
  end

  def pitch_name(abbrev)
    case abbrev
    when "FA"
      "Fastball"
    when "FT"
      "Fastball (2 seam)"
    when "FC"
      "Cutter"
    when "FS"
      "Splitter"
    when "FO"
      "Forkball"
    when "SI"
      "Sinker"
    when "SL"
      "Slider"
    when "CU"
      "Curveball"
    when "KC"
      "Knuckle-curve"
    when "EP"
      "Eephus"
    when "CH"
      "Changeup"
    when "SC"
      "Screwball"
    when "KN"
      "Knuckleball"
    when "UN"
      "Mystery pitch"
    end
  end

  def full_name
    first_name + ' ' + last_name
  end

  def average_fielding
    (fieldGrounder + fieldLiner + fieldFlyball + fieldPopup)/4
  end

  def average_throwing
    (throwShort + throwMedium + throwLong)/3
  end

  def to_s
    full_name
  end

  def set_initial_stats
    @game_atbats = 0
    @game_runs_scored = 0
    @game_hits = 0
    @game_doubles = 0
    @game_triples = 0
    @game_home_runs = 0
    @game_rbi = 0
    @game_walks = 0
    @game_strikeouts = 0
    @game_stolen_bases = 0
    @game_caught_stealing = 0
    @game_errors_committed = 0
    @game_assists = 0
    @game_putouts = 0
    @game_chances = 0
    @game_outs_recorded = 0
    @game_hits_allowed = 0
    @game_runs_allowed = 0
    @game_earned_runs_allowed = 0
    @game_walks_allowed = 0
    @game_strikeouts_recorded = 0
    @game_home_runs_allowed = 0
    @game_total_pitches = 0
    @game_strikes_thrown = 0
    @game_balls_thrown = 0
    @game_intentional_walks_allowed = 0
    @zone_pitches_thrown = Array.new(72, 0)
  end

  def logs_at_bat
    @game_atbats = @game_atbats + 1
  end

  def scores
    @game_runs_scored = @game_runs_scored + 1
  end

  def hits_single
    @game_hits = @game_hits + 1
  end

  def hits_double
    @game_doubles = @game_doubles + 1
    @game_hits = @game_hits + 1
  end

  def hits_triple
    @game_triples = @game_triples + 1
    @game_hits = @game_hits + 1
  end

  def hits_home_run
    @game_home_runs = @game_home_runs + 1
    @game_hits = @game_hits + 1
  end

  def records_rbi(num_rbi)
    @game_rbi = @game_rbi + num_rbi
  end

  def receives_walk
    @game_walks = @game_walks + 1
  end

  def strikes_out
    @game_strikeouts = @game_strikeouts + 1
  end

  def steals_base
    @game_stolen_bases = @game_stolen_bases + 1
  end

  def gets_caught_stealing
    @game_caught_stealing = @game_caught_stealing + 1
  end

  def commits_error
    @game_errors_committed = @game_errors_committed + 1
  end

  def records_assist
    @game_assists = @game_assists + 1
  end

  def records_putout
    @game_putouts = @game_putouts + 1
  end

  def records_chance
    @game_chances = @game_chances + 1
  end

  def records_out(num_outs)
    @game_outs_recorded = @game_outs_recorded + num_outs
  end

  def allows_hit
    @game_hits_allowed = @game_hits_allowed + 1
  end

  def allows_unearned_run(num_runs)
    @game_runs_allowed = @game_runs_allowed + num_runs
  end

  def allows_earned_run(num_runs)
    @game_earned_runs_allowed = @game_earned_runs_allowed + num_runs
    @game_runs_allowed = @game_runs_allowed + num_runs
  end

  def allows_walk
    @game_walks_allowed = @game_walks_allowed + 1
  end

  def records_strikeout
    @game_strikeouts_recorded = @game_strikeouts_recorded + 1
  end

  def allows_home_run
    @game_home_runs_allowed = @game_home_runs_allowed + 1
  end

  def throws_pitch(zone_number)
    @zone_pitches_thrown[zone_number - 1] += 1
    @game_total_pitches = @game_total_pitches + 1
  end

  def throws_strike
    @game_strikes_thrown = @game_strikes_thrown + 1
  end

  def throws_ball
    @game_balls_thrown = @game_balls_thrown + 1
  end

  def allows_intentional_walk
    @game_intentional_walks_allowed = @game_intentional_walks_allowed + 1
  end

  # determines how many pitches were thrown in each zone, adjusting for larger size of outer zones
  def pitches_in_specific_zone(i)

    @current_value = self["zone_#{i}_pitches".to_sym]
    if i == 1 || i == 3 || i == 70 || i == 72
      @current_value /= 5
    elsif i == 2 || i == 28 || i == 37 || i == 71
      @current_value /= 4
    end
    @current_value
  end

  def is_pitcher
    position == 'P' ? true : false
  end

  # determines the maximum number of pitches thrown in any zone
  def max_zone_pitches
    max = 0
    @current_value = 0
    for i in 1..72 do

      @current_value = self["zone_#{i}_pitches".to_sym]

      if i == 1 || i == 3 || i == 70 || i == 72
        @current_value /= 5
      elsif i == 2 || i == 28 || i == 37 || i == 71
        @current_value /= 4
      end

      if @current_value > max
        max = @current_value
      end
    end
    max
  end

end
