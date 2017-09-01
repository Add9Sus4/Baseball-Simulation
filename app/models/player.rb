# Player class.
class Player < ActiveRecord::Base

  # Player attributes (aka this is where game stats are stored for each player. These values
  # are initialized at the beginning of each game and get updated as the game progresses. Then
  # at the end of the game, player stats are updated in the database using these values.)
  attr_accessor :zone_pitches_thrown, :game_atbats, :game_runs_scored, :game_hits, :game_doubles, :game_triples, :game_home_runs, :game_rbi, :game_walks, :game_strikeouts, :game_stolen_bases, :game_caught_stealing, :game_errors_committed, :game_assists, :game_putouts, :game_chances, :game_outs_recorded, :game_hits_allowed, :game_runs_allowed, :game_earned_runs_allowed, :game_walks_allowed, :game_strikeouts_recorded, :game_home_runs_allowed, :game_total_pitches, :game_strikes_thrown, :game_balls_thrown, :game_intentional_walks_allowed

  # Make sure that all players have the following attributes when they are created
  validates :team, :first_name, :last_name, :age, :height, :weight, :position, :salary, presence: true

  # Make sure player's weight is within range (really just an excuse to try out different validations lol)
  validates_numericality_of :weight, greater_than_or_equal_to: 160, less_than_or_equal_to: 300

  # Make sure that a team does not have too many players. This is needed if you try to add
  # this player to a team that already has the max number of players.
  validate :team_cannot_have_more_than_max_players

  # This is needed to establish the one-to-many relationship between team and player
  belongs_to :team

  # A team cannot have more than the maximum number of allowable players.
  def team_cannot_have_more_than_max_players
    team = Team.find(team_id);
    totalPlayers = team.players.length

    if totalPlayers >= Team::MAX_PLAYERS
      errors.add(:base, "The " + team.city + " " + team.name + " already have the maximum number of players allowed(" + Team::MAX_PLAYERS.to_s + ").")
    end
  end

  # Creates a formatted string of all the pitches this player throws (for display purposes)
  def pitches
    str = "#{pitch_name(pitch_1)}, #{pitch_name(pitch_2)}"
    if pitch_3 != "--" then str += ", #{pitch_name(pitch_3)}" end
    if pitch_4 != "--" then str += ", #{pitch_name(pitch_4)}" end
    if pitch_5 != "--" then str += ", #{pitch_name(pitch_5)}" end
    str
  end

  # Abbreviations for different pitch types (for display purposes)
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

  # Player's full name
  def full_name
    first_name + ' ' + last_name
  end

  # Average fielding rating (displayed on player page)
  def average_fielding
    (fieldGrounder + fieldLiner + fieldFlyball + fieldPopup)/4
  end

  # Average throwing rating (displayed on player page)
  def average_throwing
    (throwShort + throwMedium + throwLong)/3
  end

  # Display player's full name when to_s is called on a player
  def to_s
    full_name
  end

  # Initialize stats before game is played
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

  # Called every time this player gets an at-bat
  def logs_at_bat
    @game_atbats = @game_atbats + 1
  end

  # Called every time this player scores a run
  def scores
    @game_runs_scored = @game_runs_scored + 1
  end

  # Called every time this player hits a single
  def hits_single
    @game_hits = @game_hits + 1
  end

  # Called every time this player hits a double
  def hits_double
    @game_doubles = @game_doubles + 1
    @game_hits = @game_hits + 1
  end

  # Called every time this player hits a triple
  def hits_triple
    @game_triples = @game_triples + 1
    @game_hits = @game_hits + 1
  end

  # Called every time this player hits a home run
  def hits_home_run
    @game_home_runs = @game_home_runs + 1
    @game_hits = @game_hits + 1
  end

  # Called every time this player drives in a run
  def records_rbi(num_rbi)
    @game_rbi = @game_rbi + num_rbi
  end

  # Called every time this player walks
  def receives_walk
    @game_walks = @game_walks + 1
  end

  # Called every time this player strikes out
  def strikes_out
    @game_strikeouts = @game_strikeouts + 1
  end

  # Called every time this player steals a base
  def steals_base
    @game_stolen_bases = @game_stolen_bases + 1
  end

  # Called every time this player gets caught stealing
  def gets_caught_stealing
    @game_caught_stealing = @game_caught_stealing + 1
  end

  # Called every time this player makes an error
  def commits_error
    @game_errors_committed = @game_errors_committed + 1
  end

  # Called every time this player records an assist (throwing to a base to get a runner out)
  def records_assist
    @game_assists = @game_assists + 1
  end

  # Called every time this player records a putout (catching a ball in order to get a runner out)
  def records_putout
    @game_putouts = @game_putouts + 1
  end

  # Called every time this player has an opportunity to make a play in the field (every chance
  # results in either an error, a putout, or an assist)
  def records_chance
    @game_chances = @game_chances + 1
  end

  # Called every time this pitcher gets a batter out
  def records_out(num_outs)
    @game_outs_recorded = @game_outs_recorded + num_outs
  end

  # Called every time this pitcher allows a hit
  def allows_hit
    @game_hits_allowed = @game_hits_allowed + 1
  end

  # Called every time this pitcher allows an unearned run
  def allows_unearned_run(num_runs)
    @game_runs_allowed = @game_runs_allowed + num_runs
  end

  # Called every time this pitcher allows an earned run
  def allows_earned_run(num_runs)
    @game_earned_runs_allowed = @game_earned_runs_allowed + num_runs
    @game_runs_allowed = @game_runs_allowed + num_runs
  end

  # Called every time this pitcher walks a batter
  def allows_walk
    @game_walks_allowed = @game_walks_allowed + 1
  end

  # Called every time this pitcher strikes out a batter
  def records_strikeout
    @game_strikeouts_recorded = @game_strikeouts_recorded + 1
  end

  # Called every time this pitcher allows a home run
  def allows_home_run
    @game_home_runs_allowed = @game_home_runs_allowed + 1
  end

  # Called every time this pitcher throws a pitch. The zone number is also recorded (this data is needed
  # so that pitcher zone maps can be displayed, showing where they typically throw the ball)
  def throws_pitch(zone_number)
    @zone_pitches_thrown[zone_number - 1] += 1
    @game_total_pitches = @game_total_pitches + 1
  end

  # Called every time this pitcher throws a strike
  def throws_strike
    @game_strikes_thrown = @game_strikes_thrown + 1
  end

  # Called every time this pitcher throws a ball
  def throws_ball
    @game_balls_thrown = @game_balls_thrown + 1
  end

  # Called every time this pitcher intentionally walks a batter
  def allows_intentional_walk
    @game_intentional_walks_allowed = @game_intentional_walks_allowed + 1
  end

  # determines how many pitches were thrown in each zone, adjusting for larger size of outer zones
  def pitches_in_specific_zone(i)

    @current_value = self["zone_#{i}_pitches".to_sym]
    if i == 1 || i == 3 || i == 70 || i == 72 # These are the corner zones (the largest), which are 5 zones in size
      @current_value /= 5
    elsif i == 2 || i == 28 || i == 37 || i == 71 # These are the outer zones that aren't the corners, which are 4 zones in size
      @current_value /= 4
    end
    @current_value # otherwise, just use the value normally, since all other zones are 1 zone in size.
  end

  # Returns true if this player is a pitcher
  def is_pitcher
    position == 'P' ? true : false
  end

   # Returns true if this pitcher is currently in the starting pitching role for their team.
  def is_starting_pitcher
    ['sp1', 'sp2', 'sp3', 'sp4', 'sp5'].include? pitching_role
  end

  # Returns the name, as a formatted string, of this player's current pitching role (for display purposes)
  def pitching_role_name
    case id
    when team.sp1, team.sp2, team.sp3, team.sp4, team.sp5
      "Starter"
    when team.lr
      "Long Relief"
    when team.mr1, team.mr2, team.mr3
      "Middle Relief"
    when team.su1, team.su2
      "Setup"
    when team.cl
      "Closer"
    end
  end

  # returns the pitching role of this player
  def pitching_role
    case id
    when team.sp1
      "sp1"
    when team.sp2
      "sp2"
    when team.sp3
      "sp3"
    when team.sp4
      "sp4"
    when team.sp5
      "sp5"
    when team.lr
      "lr"
    when team.mr1
      "mr1"
    when team.mr2
      "mr2"
    when team.mr3
      "mr3"
    when team.su1
      "su1"
    when team.su2
      "su2"
    when team.cl
      "cl"
    else
      "n/a"
    end
  end

  # Determines the maximum number of pitches thrown in any zone by this player.
  # This is needed so that all zone values can be normalized (aka scaled by the maximum),
  # which is necessary to have consistent color mapping across all players.
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
