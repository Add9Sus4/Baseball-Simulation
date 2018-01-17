# Player class.
class Player < ActiveRecord::Base
  include Reusable
  # Player attributes (aka this is where game stats are stored for each self. These values
  # are initialized at the beginning of each game and get updated as the game progresses. Then
  # at the end of the game, :player stats are updated in the database using these values.)
  attr_accessor :zone_pitches_thrown, :game_atbats, :game_runs_scored, :game_hits, :game_doubles, :game_triples,
  :game_home_runs, :game_rbi, :game_walks, :game_strikeouts, :game_stolen_bases, :game_caught_stealing,
  :game_errors_committed, :game_assists, :game_putouts, :game_chances, :game_outs_recorded, :game_hits_allowed,
  :game_runs_allowed, :game_earned_runs_allowed, :game_walks_allowed, :game_strikeouts_recorded,
  :game_home_runs_allowed, :game_total_pitches, :game_strikes_thrown, :game_balls_thrown,
  :game_intentional_walks_allowed, :pitch_array, :current_position, :lineup_position, :game_current_energy,
  :game_web_gems, :game_anti_web_gems

  # Make sure that all players have the following attributes when they are created
  validates :team, :first_name, :last_name, :height, :weight, :presence => true

  # Make sure player's weight is within range (really just an excuse to try out different validations lol)
  validates_numericality_of :weight, :greater_than_or_equal_to => 160, :less_than_or_equal_to => 300

  # Make sure that a team does not have too many players. This is needed if you try to add
  # this player to a team that already has the max number of players.
  # validate :team_cannot_have_more_than_max_players

  # This is needed to establish the one-to-many relationship between team and player
  belongs_to :team
  has_many :season_attributes
  has_many :season_batting_stats
  has_many :season_fielding_stats
  has_many :season_pitching_stats
  has_many :achievements

  # Calculates salary for this player based on current attributes
  def calculateSalary
    salary = 0
    exp_factor = 2.2
    actual_factor = 0.75
    potential_factor = 0.25
    if position == "P"
      salary += movement**exp_factor*100*actual_factor
      salary += control**exp_factor*75*actual_factor
      salary += location**exp_factor*75*actual_factor
      salary += arm_strength**exp_factor*100*actual_factor
      salary += intelligence**exp_factor*50*actual_factor
      salary += endurance**exp_factor*75*actual_factor
      salary += movement_potential**exp_factor*100*potential_factor
      salary += control_potential**exp_factor*75*potential_factor
      salary += location_potential**exp_factor*75*potential_factor
      salary += arm_strength_potential**exp_factor*100*potential_factor
      salary += intelligence_potential**exp_factor*50*potential_factor
      salary += endurance_potential**exp_factor*75*potential_factor
    else
      salary += power**exp_factor*100*actual_factor
      salary += batting_average**exp_factor*100*actual_factor
      salary += contact**exp_factor*15*actual_factor
      salary += plate_vision**exp_factor*50*actual_factor
      salary += patience**exp_factor*50*actual_factor
      salary += intelligence**exp_factor*50*actual_factor
      salary += uppercut_amount**exp_factor*75*actual_factor
      salary += speed**exp_factor*50*actual_factor
      salary += power_potential**exp_factor*100*potential_factor
      salary += batting_average_potential**exp_factor*100*potential_factor
      salary += contact_potential**exp_factor*15*potential_factor
      salary += plate_vision_potential**exp_factor*50*potential_factor
      salary += patience_potential**exp_factor*50*potential_factor
      salary += intelligence_potential**exp_factor*50*potential_factor
      salary += uppercut_amount_potential**exp_factor*75*potential_factor
      salary += speed_potential**exp_factor*50*potential_factor
    end
    salary += reaction_time**exp_factor*25*actual_factor
    salary += agility**exp_factor*25*actual_factor
    salary += reaction_time_potential**exp_factor*25*potential_factor
    salary += agility_potential**exp_factor*25*potential_factor

    salary *= rand(0.9..1.11)
  end

  # Creates a formatted string of all the pitches this player throws (for display purposes)
  def pitches
    str = "#{pitch_name(pitch_1)}, #{pitch_name(pitch_2)}"
    if pitch_3 != "--" then str += ", #{pitch_name(pitch_3)}" end
    if pitch_4 != "--" then str += ", #{pitch_name(pitch_4)}" end
    if pitch_5 != "--" then str += ", #{pitch_name(pitch_5)}" end
    str
  end

  def update_current_attributes
    update_attributes(:current_energy => 100, :age => self.age + 1,
    :power => increment_attribute(self.power, self.power_potential),
    :contact => increment_attribute(self.contact, self.contact_potential),
    :speed => increment_attribute(self.speed, self.speed_potential),
    :patience => increment_attribute(self.patience, self.patience_potential),
    :plate_vision => increment_attribute(self.plate_vision, self.plate_vision_potential),
    :batting_average => increment_attribute(self.batting_average, self.batting_average_potential),
    :movement => increment_attribute(self.movement, self.movement_potential),
    :control => increment_attribute(self.control, self.control_potential),
    :location => increment_attribute(self.location, self.location_potential),
    :agility => increment_attribute(self.agility, self.agility_potential),
    :reaction_time => increment_attribute(self.reaction_time, self.reaction_time_potential),
    :arm_strength => increment_attribute(self.arm_strength, self.arm_strength_potential),
    :field_grounder => increment_attribute(self.field_grounder, self.field_grounder_potential),
    :field_liner => increment_attribute(self.field_liner, self.field_liner_potential),
    :field_flyball => increment_attribute(self.field_flyball, self.field_flyball_potential),
    :field_popup => increment_attribute(self.field_popup, self.field_popup_potential),
    :throw_short => increment_attribute(self.throw_short, self.throw_short_potential),
    :throw_medium => increment_attribute(self.throw_medium, self.throw_medium_potential),
    :throw_long => increment_attribute(self.throw_long, self.throw_long_potential),
    :endurance => increment_attribute(self.endurance, self.endurance_potential),
    :intelligence => increment_intelligence)
    update_attributes(:salary => self.calculateSalary)
  end

  # Intelligence declines at an increasingly rapid pace after age 30 (causing a decline in all ratings as the player ages)
  def increment_intelligence
    decrease = 0
    case age
    when 30
      decrease = 1
    when 31
      decrease = 3
    when 32
      decrease = 5
    when 33
      decrease = 7
    when 34
      decrease = 9
    when 35
      decrease = 11
    when 36
      decrease = 13
    when 37
      decrease = 15
    when 38
      decrease = 17
    when 39
      decrease = 19
    end
    [intelligence - decrease, 0].max
  end

  # Method called on a player to determine if they will retire, and if so, make appropriate changes. Return true if the player retires, false otherwise
  def retires?(current_date)
    if self.age < 40
      return false
    end # Player will only retire when they hit age 40 TODO: make this more nuanced
    puts "#{self.full_name} retires (#{self.position}, #{self.team.full_name})."
    update_attributes(:retired => 1, :level => "Retired")
    if self.team_id == 2 || self.level == "Minors" || self.position == "BN"
      return true
    end # If player was a free agent, a bench player, or a minor leaguer, no further action required
    team = self.team
    if self.position == "P" # If the player was a pitcher
      puts "signing best available free agent pitcher..." # highest-salaried free agent pitcher chosen
      newPlayer = Player.where("team_id = 2 AND position = 'P' AND retired != 1 AND age < 40").sort_by { |player| -player.salary }.first
      if newPlayer == nil # If no free agent pitcher exists, create one
        puts "no free agent pitcher available. Creating one..."
        newPlayer = completely_random_pitcher(team.id, false)
      end
      puts "#{newPlayer.full_name} signed by the #{self.team.full_name}."
      newPlayer.update_columns(:level => "Active", :team_id => team.id)
      Transaction.create!(team_id: team.id, transaction_type: "Signing", signed_player_id: newPlayer.id, transaction_date: current_date)
      case self.id # Update pitching role for new player
      when team.sp1
        team.update_columns(:sp1 => newPlayer.id)
      when team.sp2
        team.update_columns(:sp2 => newPlayer.id)
      when team.sp3
        team.update_columns(:sp3 => newPlayer.id)
      when team.sp4
        team.update_columns(:sp4 => newPlayer.id)
      when team.sp5
        team.update_columns(:sp5 => newPlayer.id)
      when team.lr
        team.update_columns(:lr => newPlayer.id)
      when team.mr1
        team.update_columns(:mr1 => newPlayer.id)
      when team.mr2
        team.update_columns(:mr2 => newPlayer.id)
      when team.mr3
        team.update_columns(:mr3 => newPlayer.id)
      when team.su1
        team.update_columns(:su1 => newPlayer.id)
      when team.su2
        team.update_columns(:su2 => newPlayer.id)
      when team.cl
        team.update_columns(:cl => newPlayer.id)
      end
    end
    if self.position != "P" # If the player was a position player
      puts "signing best available free agent position player..." # Sign highest-salary free agent position player
      newPlayer = Player.where("team_id = 2 AND position != 'P' AND retired != 1 AND age < 40").sort_by { |player| -player.salary }.first
      if newPlayer == nil # If no free agent position player exists, create one
        puts "no free agent position player available. Creating one..."
        newPlayer = completely_random_player(team.id, false)
      end
      puts "#{newPlayer.full_name} signed by the #{self.team.full_name}."
      newPlayer.update_columns(:level => "Active", :team_id => team.id)
      Transaction.create!(team_id: team.id, transaction_type: "Signing", signed_player_id: newPlayer.id, transaction_date: current_date)
      # Update position for new player
      case self.id
      when team.catcher
        team.update_columns(:catcher => newPlayer.id)
      when team.designated_hitter
        team.update_columns(:designated_hitter => newPlayer.id)
      when team.first_base
        team.update_columns(:first_base => newPlayer.id)
      when team.second_base
        team.update_columns(:second_base => newPlayer.id)
      when team.third_base
        team.update_columns(:third_base => newPlayer.id)
      when team.shortstop
        team.update_columns(:shortstop => newPlayer.id)
      when team.left_field
        team.update_columns(:left_field => newPlayer.id)
      when team.center_field
        team.update_columns(:center_field => newPlayer.id)
      when team.right_field
        team.update_columns(:right_field => newPlayer.id)
      end
    end
    return true
  end

  # Resets all season stats for this player
  def reset_season_stats
    update_attributes(:current_energy => 100, :atbats => 0, :runs => 0, :hits => 0, :doubles => 0, :triples => 0, :home_runs => 0,
      :rbi => 0, :walks => 0, :strikeouts => 0, :stolen_bases => 0, :caught_stealing => 0, :games => 0, :errors_committed => 0,
      :assists => 0, :putouts => 0, :chances => 0, :outs_recorded => 0, :hits_allowed => 0, :runs_allowed => 0, :earned_runs_allowed => 0,
      :walks_allowed => 0, :strikeouts_recorded => 0, :home_runs_allowed => 0, :total_pitches => 0, :strikes_thrown => 0,
      :balls_thrown => 0, :intentional_walks_allowed => 0, :wins => 0, :losses => 0, :saves => 0, :blown_saves => 0, :holds => 0,
      :zone_1_pitches => 0, :zone_2_pitches => 0, :zone_3_pitches => 0, :zone_4_pitches => 0, :zone_5_pitches => 0, :zone_6_pitches => 0,
      :zone_7_pitches => 0, :zone_8_pitches => 0, :zone_9_pitches => 0, :zone_10_pitches => 0, :zone_11_pitches => 0,
      :zone_12_pitches => 0, :zone_13_pitches => 0, :zone_14_pitches => 0, :zone_15_pitches => 0, :zone_16_pitches => 0,
      :zone_17_pitches => 0, :zone_18_pitches => 0, :zone_19_pitches => 0, :zone_20_pitches => 0, :zone_21_pitches => 0,
      :zone_22_pitches => 0, :zone_23_pitches => 0, :zone_24_pitches => 0, :zone_25_pitches => 0, :zone_26_pitches => 0,
      :zone_27_pitches => 0, :zone_28_pitches => 0, :zone_29_pitches => 0, :zone_30_pitches => 0, :zone_31_pitches => 0,
      :zone_32_pitches => 0, :zone_33_pitches => 0, :zone_34_pitches => 0, :zone_35_pitches => 0, :zone_36_pitches => 0,
      :zone_37_pitches => 0, :zone_38_pitches => 0, :zone_39_pitches => 0, :zone_40_pitches => 0, :zone_41_pitches => 0,
      :zone_42_pitches => 0, :zone_43_pitches => 0, :zone_44_pitches => 0, :zone_45_pitches => 0, :zone_46_pitches => 0,
      :zone_47_pitches => 0, :zone_48_pitches => 0, :zone_49_pitches => 0, :zone_50_pitches => 0, :zone_51_pitches => 0,
      :zone_52_pitches => 0, :zone_53_pitches => 0, :zone_54_pitches => 0, :zone_55_pitches => 0, :zone_56_pitches => 0,
      :zone_57_pitches => 0, :zone_58_pitches => 0, :zone_59_pitches => 0, :zone_60_pitches => 0, :zone_61_pitches => 0,
      :zone_62_pitches => 0, :zone_63_pitches => 0, :zone_64_pitches => 0, :zone_65_pitches => 0, :zone_66_pitches => 0,
      :zone_67_pitches => 0, :zone_68_pitches => 0, :zone_69_pitches => 0, :zone_70_pitches => 0, :zone_71_pitches => 0,
      :zone_72_pitches => 0, :web_gems => 0, :anti_web_gems => 0)
  end

  def save_season_attributes(season_id)
    SeasonAttribute.create!(:player_id => self.id,
    :season_id => season_id,
    :team_id => self.team_id,
    :age => self.age,
    :position => self.position,
    :salary => self.salary,
    :power => self.power,
    :contact => self.contact,
    :speed => self.speed,
    :patience => self.patience,
    :plate_vision => self.plate_vision,
    :pull_amount => self.pull_amount,
    :uppercut_amount => self.uppercut_amount,
    :batting_average => self.batting_average,
    :movement => self.movement,
    :control => self.control,
    :location => self.location,
    :agility => self.agility,
    :reaction_time => self.reaction_time,
    :arm_strength => self.arm_strength,
    :field_grounder => self.field_grounder,
    :field_liner => self.field_liner,
    :field_flyball => self.field_flyball,
    :field_popup => self.field_popup,
    :throw_short => self.throw_short,
    :throw_medium => self.throw_medium,
    :throw_long => self.throw_long,
    :intelligence => self.intelligence,
    :endurance => self.endurance,
    :clutch => self.clutch)
  end

  def save_season_batting_stats(season_id)
    SeasonBattingStat.create!(:player_id => self.id, :season_id => season_id, :team_id => self.team_id, :atbats => self.atbats,
    :runs => self.runs, :hits => self.hits, :doubles => self.doubles, :triples => self.triples, :home_runs => self.home_runs,
    :rbi => self.rbi, :walks => self.walks, :intentional_walks => self.intentional_walks, :strikeouts => self.strikeouts,
    :stolen_bases => self.stolen_bases, :caught_stealing => self.caught_stealing, :games => self.games)
  end

  def save_season_fielding_stats(season_id)
    SeasonFieldingStat.create!(:player_id => self.id,
    :season_id => season_id,
    :team_id => self.team_id,
    :errors_committed => self.errors_committed,
    :assists => self.assists,
    :putouts => self.putouts,
    :chances => self.chances,
    :games => self.games,
    :web_gems => self.web_gems,
    :anti_web_gems => self.anti_web_gems)
  end

  def save_season_pitching_stats(season_id)
    SeasonPitchingStat.create!(:player_id => self.id, :season_id => season_id, :team_id => self.team_id, :outs_recorded => self.outs_recorded,
    :hits_allowed => self.hits_allowed, :runs_allowed => self.runs_allowed, :earned_runs_allowed => self.earned_runs_allowed,
    :walks_allowed => self.walks_allowed, :strikeouts_recorded => self.strikeouts_recorded, :home_runs_allowed => self.home_runs_allowed,
    :total_pitches => self.total_pitches, :strikes_thrown => self.strikes_thrown, :balls_thrown => self.balls_thrown,
    :intentional_walks_allowed => self.intentional_walks_allowed, :wins => self.wins, :losses => self.losses, :saves => self.saves,
    :blown_saves => self.blown_saves, :holds => self.holds, :games => self.games, :zone_1_pitches => self.zone_1_pitches,
    :zone_2_pitches => self.zone_2_pitches, :zone_3_pitches => self.zone_3_pitches, :zone_4_pitches => self.zone_4_pitches,
    :zone_5_pitches => self.zone_5_pitches, :zone_6_pitches => self.zone_6_pitches, :zone_7_pitches => self.zone_7_pitches,
    :zone_8_pitches => self.zone_8_pitches, :zone_9_pitches => self.zone_9_pitches, :zone_10_pitches => self.zone_10_pitches,
    :zone_11_pitches => self.zone_11_pitches, :zone_12_pitches => self.zone_12_pitches, :zone_13_pitches => self.zone_13_pitches,
    :zone_14_pitches => self.zone_14_pitches, :zone_15_pitches => self.zone_15_pitches, :zone_16_pitches => self.zone_16_pitches,
    :zone_17_pitches => self.zone_17_pitches, :zone_18_pitches => self.zone_18_pitches, :zone_19_pitches => self.zone_19_pitches,
    :zone_20_pitches => self.zone_20_pitches, :zone_21_pitches => self.zone_21_pitches, :zone_22_pitches => self.zone_22_pitches,
    :zone_23_pitches => self.zone_23_pitches, :zone_24_pitches => self.zone_24_pitches, :zone_25_pitches => self.zone_25_pitches,
    :zone_26_pitches => self.zone_26_pitches, :zone_27_pitches => self.zone_27_pitches, :zone_28_pitches => self.zone_28_pitches,
    :zone_29_pitches => self.zone_29_pitches, :zone_30_pitches => self.zone_30_pitches, :zone_31_pitches => self.zone_31_pitches,
    :zone_32_pitches => self.zone_32_pitches, :zone_33_pitches => self.zone_33_pitches, :zone_34_pitches => self.zone_34_pitches,
    :zone_35_pitches => self.zone_35_pitches, :zone_36_pitches => self.zone_36_pitches, :zone_37_pitches => self.zone_37_pitches,
    :zone_38_pitches => self.zone_38_pitches, :zone_39_pitches => self.zone_39_pitches, :zone_40_pitches => self.zone_40_pitches,
    :zone_41_pitches => self.zone_41_pitches, :zone_42_pitches => self.zone_42_pitches, :zone_43_pitches => self.zone_43_pitches,
    :zone_44_pitches => self.zone_44_pitches, :zone_45_pitches => self.zone_45_pitches, :zone_46_pitches => self.zone_46_pitches,
    :zone_47_pitches => self.zone_47_pitches, :zone_48_pitches => self.zone_48_pitches, :zone_49_pitches => self.zone_49_pitches,
    :zone_50_pitches => self.zone_50_pitches, :zone_51_pitches => self.zone_51_pitches, :zone_52_pitches => self.zone_52_pitches,
    :zone_53_pitches => self.zone_53_pitches, :zone_54_pitches => self.zone_54_pitches, :zone_55_pitches => self.zone_55_pitches,
    :zone_56_pitches => self.zone_56_pitches, :zone_57_pitches => self.zone_57_pitches, :zone_58_pitches => self.zone_58_pitches,
    :zone_59_pitches => self.zone_59_pitches, :zone_60_pitches => self.zone_60_pitches, :zone_61_pitches => self.zone_61_pitches,
    :zone_62_pitches => self.zone_62_pitches, :zone_63_pitches => self.zone_63_pitches, :zone_64_pitches => self.zone_64_pitches,
    :zone_65_pitches => self.zone_65_pitches, :zone_66_pitches => self.zone_66_pitches, :zone_67_pitches => self.zone_67_pitches,
    :zone_68_pitches => self.zone_68_pitches, :zone_69_pitches => self.zone_69_pitches, :zone_70_pitches => self.zone_70_pitches)
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
    (field_grounder + field_liner + field_flyball + field_popup)/4
  end

  # Average potential fielding rating (displayed on player page)
  def average_fielding_potential
    (field_grounder_potential + field_liner_potential + field_flyball_potential + field_popup_potential)/4
  end

  # Average throwing rating (displayed on player page)
  def average_throwing
    (throw_short + throw_medium + throw_long)/3
  end

  # Average potential throwing rating (displayed on player page)
  def average_throwing_potential
    (throw_short_potential + throw_medium_potential + throw_long_potential)/3
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
    @game_web_gems = 0
    @game_anti_web_gems = 0
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
    @pitch_array = Array.new
    @game_current_energy = current_energy
    if (pitch_1 != "--") then @pitch_array.push(pitch_1) end
    if (pitch_2 != "--") then @pitch_array.push(pitch_2) end
    if (pitch_3 != "--") then @pitch_array.push(pitch_3) end
    if (pitch_4 != "--") then @pitch_array.push(pitch_4) end
    if (pitch_5 != "--") then @pitch_array.push(pitch_5) end
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

  # Called every time this player makes a defensive play that an average defender wouldn't have made
  def records_web_gem
    @game_web_gems += 1
  end

  # Called every time this player doesn't make a defensive play that an average defender would have made
  def records_anti_web_gem
    @game_anti_web_gems += 1
  end

  # Called every time this player makes an error
  def commits_error
    @game_errors_committed = @game_errors_committed + 1
    records_chance
  end

  # Called every time this player records an assist (throwing to a base to get a runner out)
  def records_assist
    @game_assists = @game_assists + 1
    records_chance
  end

  # Called every time this player records a putout (catching a ball in order to get a runner out)
  def records_putout
    @game_putouts = @game_putouts + 1
    records_chance
  end

  # Called every time this player has an opportunity to make a play in the field (every chance
  # results in either an error, :a putout, :or an assist)
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

  # Returns a pitcher's armStrength attribute, :adjusted for endurance penalty
  def get_arm_strength
    arm_strength*map_attribute_to_range(arm_strength, AttributeAdjustments::PITCHER_ENDURANCE_AFFECTS_ARM_STRENGTH_MIN, AttributeAdjustments::PITCHER_ENDURANCE_AFFECTS_ARM_STRENGTH_MAX, false)
  end

  # Returns a pitcher's control attribute, :adjusted for endurance penalty
  def get_control
    control*map_attribute_to_range(control, AttributeAdjustments::PITCHER_ENDURANCE_AFFECTS_CONTROL_MIN, AttributeAdjustments::PITCHER_ENDURANCE_AFFECTS_CONTROL_MAX, false)
  end

  # Returns a pitcher's location attribute, :adjusted for endurance penalty
  def get_location
    location*map_attribute_to_range(control, AttributeAdjustments::PITCHER_ENDURANCE_AFFECTS_LOCATION_MIN, AttributeAdjustments::PITCHER_ENDURANCE_AFFECTS_LOCATION_MAX, false)
  end

  # Called every time this pitcher throws a pitch. The zone number is also recorded (this data is needed
  # so that pitcher zone maps can be displayed, :showing where they typically throw the ball)
  def throws_pitch(zone_number)
    @game_current_energy -= map_attribute_to_range(endurance, AttributeAdjustments::PITCHER_ENDURANCE_AFFECTS_ENERGY_LOSS_PER_PITCH_MIN, AttributeAdjustments::PITCHER_ENDURANCE_AFFECTS_ENERGY_LOSS_PER_PITCH_MAX, true)
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

  # determines how many pitches were thrown in each zone, :adjusting for larger size of outer zones
  def pitches_in_specific_zone(i)

    @current_value = self["zone_#{i}_pitches".to_sym]
    if i == 1 || i == 3 || i == 70 || i == 72 # These are the corner zones (the largest), :which are 5 zones in size
      @current_value /= 5
    elsif i == 2 || i == 28 || i == 37 || i == 71 # These are the outer zones that aren't the corners, :which are 4 zones in size
      @current_value /= 4
    end
    @current_value # otherwise, :just use the value normally, :since all other zones are 1 zone in size.
  end

  # Returns true if this player is a pitcher
  def is_pitcher
    position == 'P' ? true : false
  end

   # Returns true if this pitcher is currently in the starting pitching role for their team.
  def is_starting_pitcher
    ['sp1', 'sp2', 'sp3', 'sp4', 'sp5'].include? pitching_role
  end

  # Returns the name, :as a formatted string, :of this player's current pitching role (for display purposes)
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

  # Returns a player's height, :formatted in feet and inches
  def formatted_height
    feet = (height/12).floor
    inches = height - feet*12
    "#{feet}\' #{inches}\'\'"
  end

  # Returns the name, :as a formatted string, :of this player's natural position (for display purposes)
  def natural_position_name
    case position
    when "C"
      "Catcher"
    when "DH"
      "Designated Hitter"
    when "1B"
      "First Base"
    when "2B"
      "Second Base"
    when "3B"
      "Third Base"
    when "SS"
      "Shortstop"
    when "LF"
      "Left Field"
    when "CF"
      "Center Field"
    when "RF"
      "Right Field"
    else
      "Bench"
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

  # Each season this is called to increment attributes
  def increment_attribute(attribute, attribute_potential)

    max_increase = map_attribute_to_range(intelligence, AttributeAdjustments::PLAYER_INTELLIGENCE_AFFECTS_ATTRIBUTE_IMPROVEMENT_MIN, AttributeAdjustments::PLAYER_INTELLIGENCE_AFFECTS_ATTRIBUTE_IMPROVEMENT_MAX, false)
    max_decrease = map_attribute_to_range(intelligence, AttributeAdjustments::PLAYER_INTELLIGENCE_AFFECTS_ATTRIBUTE_DECLINE_MIN, AttributeAdjustments::PLAYER_INTELLIGENCE_AFFECTS_ATTRIBUTE_DECLINE_MAX, true)
    actual_increase = rand(0..max_increase)
    actual_decrease = rand(0..max_decrease)

    increase_scale = 1.81746 - 0.0456349*age.to_f
    decrease_scale = 0.0468254*age.to_f - 0.862698

    [[attribute + actual_increase*increase_scale - actual_decrease*decrease_scale, attribute_potential].min, 0].max
  end



  # Determines the maximum number of pitches thrown in any zone by this self.
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
