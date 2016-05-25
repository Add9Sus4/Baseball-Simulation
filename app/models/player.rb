class Player < ActiveRecord::Base
  attr_accessor :at_bats, :runs_scored, :hits, :doubles, :triples, :home_runs, :rbi, :walks, :strikeouts, :stolen_bases, :caught_stealing, :errors_committed, :assists, :putouts, :chances, :outs_recorded, :hits_allowed, :runs_allowed, :earned_runs_allowed, :walks_allowed, :strikeouts_recorded, :home_runs_allowed, :total_pitches, :strikes_thrown, :balls_thrown, :intentional_walks_allowed

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
    @at_bats = 0
    @runs_scored = 0
    @hits = 0
    @doubles = 0
    @triples = 0
    @home_runs = 0
    @rbi = 0
    @walks = 0
    @strikeouts = 0
    @stolen_bases = 0
    @caught_stealing = 0
    @errors_committed = 0
    @assists = 0
    @putouts = 0
    @chances = 0
    @outs_recorded = 0
    @hits_allowed = 0
    @runs_allowed = 0
    @earned_runs_allowed = 0
    @walks_allowed = 0
    @strikeouts_recorded = 0
    @home_runs_allowed = 0
    @total_pitches = 0
    @strikes_thrown = 0
    @balls_thrown = 0
    @intentional_walks_allowed = 0
  end

  def logs_at_bat
    @at_bats = @at_bats + 1
  end

  def scores
    @runs_scored = @runs_scored + 1
  end

  def hits_single
    @hits = @hits + 1
  end

  def hits_double
    @doubles = @doubles + 1
    @hits = @hits + 1
  end

  def hits_triple
    @triples = @triples + 1
    @hits = @hits + 1
  end

  def hits_home_run
    @home_runs = @home_runs + 1
    @hits = @hits + 1
  end

  def records_rbi(num_rbi)
    @rbi = @rbi + num_rbi
  end

  def receives_walk
    @walks = @walks + 1
  end

  def strikes_out
    @strikeouts = @strikeouts + 1
  end

  def steals_base
    @stolen_bases = @stolen_bases + 1
  end

  def gets_caught_stealing
    @caught_stealing = @caught_stealing + 1
  end

  def commits_error
    @errors_committed = @errors_committed + 1
  end

  def records_assist
    @assists = @assists + 1
  end

  def records_putout
    @putouts = @putouts + 1
  end

  def records_chance
    @chances = @chances + 1
  end

  def records_out(num_outs)
    @outs_recorded = @outs_recorded + num_outs
  end

  def allows_hit
    @hits_allowed = @hits_allowed + 1
  end

  def allows_unearned_run(num_runs)
    @runs_allowed = @runs_allowed + num_runs
  end

  def allows_earned_run(num_runs)
    @earned_runs_allowed = @earned_runs_allowed + num_runs
    @runs_allowed = @runs_allowed + num_runs
  end

  def allows_walk
    @walks = @walks + 1
  end

  def records_strikeout
    @strikeouts_recorded = @strikeouts_recorded + 1
  end

  def allows_home_run
    @home_runs_allowed = @home_runs_allowed + 1
    allows_hit
  end

  def throws_pitch
    @total_pitches = @total_pitches + 1
  end

  def throws_strike
    @strikes_thrown = @strikes_thrown + 1
  end

  def throws_ball
    @balls_thrown = @balls_thrown + 1
  end

  def allows_intentional_walk
    @intentional_walks_allowed = @intentional_walks_allowed + 1
  end

end
