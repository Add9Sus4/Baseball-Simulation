# Team class.
class Team < ActiveRecord::Base

  attr_accessor :game_lineup_position, # what lineup spot is currently up
  :game_pitcher_list, # list of all pitchers that have pitched in the current game
  :game_score, # number of runs scored by this team in the current game
  :game_inning_scores, # string representing runs scored each inning, separated by '_'
  :in_line_for_loss, # if this team is losing, which pitcher would get the loss if the game ended now?
  :in_line_for_win, # if this team is winning, which pitcher woudl get the win if the game ended now?
  :game_lineup, # string of ids representing the players in the lineup, in order, separated by '_'
  :game_lineup_players, # array of players in the lineup, in order.
  :game_position_players # hash of players at each position (key = position abbreviation)

  # A team must have all the following attributes when it is created:
  # validates :city, :name, :league, :division, :stadium, :capacity, presence: true

  # A team cannot have more than one player at the same position
  validate :players_must_not_be_at_same_position

  # This line is necessary to establish the one-to-many relationship between team and player.
  # It also ensures that when a team is removed from the database, all of its players are also removed.
  has_many :players, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  has_many :season_team_stats

  # This line is necessary so that when you edit the team, you can also edit players associated
  # with the team using the same form
  accepts_nested_attributes_for :players

  # This line is necessary to establish the one-to-many relationship between user and team.
  belongs_to :user

  # Displays the full name of the team
  def full_name
    if id == 1
      "Draft List"
    elsif id == 2
      "Free Agents"
    else
      city + ' ' + name
    end
  end

  # Resets all season stats for this team
  def reset_season_stats
    update_attributes(:wins => 0,
    :losses => 0,
    :runs_scored => 0,
    :runs_allowed => 0,
    :streak => 0,
    :rotation_position => 1,
    :division_series_wins => 0,
    :championship_series_wins => 0,
    :world_series_wins => 0)
  end

  def save_season_stats(season_id)
      SeasonTeamStat.create!(:team_id => self.id,
      :season_id => season_id,
      :wins => self.wins,
      :losses => self.losses,
      :runs_scored => self.runs_scored,
      :runs_allowed => self.runs_allowed,
      :league => self.league,
      :division => self.division,
      :division_series_wins => self.division_series_wins,
      :championship_series_wins => self.championship_series_wins,
      :world_series_wins => self.world_series_wins)
  end

  # Returns an array of position players in the minor league system of this team
  def get_position_players_in_minors
    Player.where("team_id = ? AND level = ? AND retired != ? AND position != ?", self.id, "Minors", 1, "P")
  end

  # Returns an array of pitchers in the minor league system of this team
  def get_pitchers_in_minors
    Player.where("team_id = ? AND level = ? AND retired != ? AND position = ?", self.id, "Minors", 1, "P")
  end

  # Returns an array of position players on the active roster of this team
  def get_position_players_on_active_roster
    Player.where("team_id = ? AND level = ? AND retired != ? AND position != ?", self.id, "Active", 1, "P")
  end

  # Returns an array of pitchers on the active roster of this team
  def get_pitchers_on_active_roster
    Player.where("team_id = ? AND level = ? AND retired != ? AND position = ?", self.id, "Active", 1, "P")
  end

  # This method drops old_player to free agency and replaces them with new_player
  def replace_position_player(new_player, old_player)
    case old_player.id
    when catcher
      update_attributes(:catcher => new_player.id)
    when designated_hitter
      update_attributes(:designated_hitter => new_player.id)
    when first_base
      update_attributes(:first_base => new_player.id)
    when second_base
      update_attributes(:second_base => new_player.id)
    when third_base
      update_attributes(:third_base => new_player.id)
    when shortstop
      update_attributes(:shortstop => new_player.id)
    when left_field
      update_attributes(:left_field => new_player.id)
    when center_field
      update_attributes(:center_field => new_player.id)
    when right_field
      update_attributes(:right_field => new_player.id)
    end
    new_player.update_columns(:level => "Active", :team_id => self.id)
    old_player.update_columns(:team_id => 2)
    self.save!
  end

  # This method drops old_player to free agency and replaces them with new_player
  def replace_pitcher(new_player, old_player)
    case old_player.id
    when sp1
      update_attributes(:sp1 => new_player.id)
    when sp2
      update_attributes(:sp2 => new_player.id)
    when sp3
      update_attributes(:sp3 => new_player.id)
    when sp4
      update_attributes(:sp4 => new_player.id)
    when sp5
      update_attributes(:sp5 => new_player.id)
    when lr
      update_attributes(:lr => new_player.id)
    when mr1
      update_attributes(:mr1 => new_player.id)
    when mr2
      update_attributes(:mr2 => new_player.id)
    when mr3
      update_attributes(:mr3 => new_player.id)
    when su1
      update_attributes(:su1 => new_player.id)
    when su2
      update_attributes(:su2 => new_player.id)
    when cl
      update_attributes(:cl => new_player.id)
    end
    new_player.update_columns(:level => "Active", :team_id => self.id)
    old_player.update_columns(:team_id => 2)
    self.save!
  end

  # This method attempts to place players at the right positions in the roster
  def optimize_roster(date)
    used_ids = [] # don't drop a player you just added
    puts "Optimizing roster for the #{self.full_name}..."
    # First, check if there are any players in the minors that are better than players on the active roster. If so, promote them and drop the active player
    puts "Optimizing position players..."
    get_position_players_on_active_roster.sort_by { |player| player.salary }.each do |player_on_active_roster|
      found = false
      get_position_players_in_minors.sort_by { |player| -player.salary }.each do |player_in_minors|
        if player_in_minors.salary > player_on_active_roster.salary && !found && !used_ids.include?(player_in_minors.id) && !used_ids.include?(player_on_active_roster.id)
          puts "#{player_in_minors.full_name} (#{player_in_minors.salary}) brought up from the minors to replace #{player_on_active_roster.full_name} (#{player_on_active_roster.salary})"
          replace_position_player(player_in_minors, player_on_active_roster)
          used_ids.push(player_in_minors.id)
          used_ids.push(player_on_active_roster.id)
          Transaction.create!(team_id: self.id, transaction_type: "Promotion", promoted_player_id: player_in_minors.id, dropped_player_id: player_on_active_roster.id, transaction_date: date)
          found = true
        end
      end
    end
    puts "Optimizing pitchers..."
    get_pitchers_on_active_roster.sort_by { |player| player.salary }.each do |player_on_active_roster|
      found = false
      get_pitchers_in_minors.sort_by { |player| -player.salary }.each do |player_in_minors|
        if player_in_minors.salary > player_on_active_roster.salary && !found && !used_ids.include?(player_in_minors.id) && !used_ids.include?(player_on_active_roster.id)
          puts "#{player_in_minors.full_name} (#{player_in_minors.salary}) brought up from the minors to replace #{player_on_active_roster.full_name} (#{player_on_active_roster.salary})"
          replace_pitcher(player_in_minors, player_on_active_roster)
          used_ids.push(player_in_minors.id)
          used_ids.push(player_on_active_roster.id)
          Transaction.create!(team_id: self.id, transaction_type: "Promotion", promoted_player_id: player_in_minors.id, dropped_player_id: player_on_active_roster.id, transaction_date: date)
          found = true
        end
      end
    end
    puts "Optimizing lineup..."
    position_players = get_position_players_on_active_roster.sort_by { |player| player.salary }
    players_that_should_be_on_bench = position_players[0..3]
    players_that_should_be_starting = position_players[4..12]
    players_that_should_be_on_bench.each do |bench_player| # Search all players that should be on the bench
      if find_position_abbreviation_of_player(bench_player.id) != "BN" # If they aren't on the bench
        players_that_should_be_starting.each do |starting_player| # Search all players that are starting
          if find_position_abbreviation_of_player(starting_player.id) == "BN" # If they are on the bench
            substitute_player(starting_player, bench_player) # Put the starting player in the starting lineup and bench the bench player
            break
          end
        end
      end
    end
  end

  # Puts new_player in the position of old_player, old_player goes to the bench
  def substitute_player(new_player, old_player)
    case old_player.id
    when catcher
      puts "#{new_player.full_name} (#{new_player.salary}) now starting at catcher for the #{self.full_name}, #{old_player.full_name} (#{old_player.salary}) moved to the bench."
      update_attributes(:catcher => new_player.id)
    when designated_hitter
      puts "#{new_player.full_name} (#{new_player.salary}) now starting at DH for the #{self.full_name}, #{old_player.full_name} (#{old_player.salary}) moved to the bench."
      update_attributes(:designated_hitter => new_player.id)
    when first_base
      puts "#{new_player.full_name} (#{new_player.salary}) now starting at first base for the #{self.full_name}, #{old_player.full_name} (#{old_player.salary}) moved to the bench."
      update_attributes(:first_base => new_player.id)
    when second_base
      puts "#{new_player.full_name} (#{new_player.salary}) now starting at second base for the #{self.full_name}, #{old_player.full_name} (#{old_player.salary}) moved to the bench."
      update_attributes(:second_base => new_player.id)
    when third_base
      puts "#{new_player.full_name} (#{new_player.salary}) now starting at third base for the #{self.full_name}, #{old_player.full_name} (#{old_player.salary}) moved to the bench."
      update_attributes(:third_base => new_player.id)
    when shortstop
      puts "#{new_player.full_name} (#{new_player.salary}) now starting at shortstop for the #{self.full_name}, #{old_player.full_name} (#{old_player.salary}) moved to the bench."
      update_attributes(:shortstop => new_player.id)
    when left_field
      puts "#{new_player.full_name} (#{new_player.salary}) now starting at left field for the #{self.full_name}, #{old_player.full_name} (#{old_player.salary}) moved to the bench."
      update_attributes(:left_field => new_player.id)
    when center_field
      puts "#{new_player.full_name} (#{new_player.salary}) now starting at center field for the #{self.full_name}, #{old_player.full_name} (#{old_player.salary}) moved to the bench."
      update_attributes(:center_field => new_player.id)
    when right_field
      puts "#{new_player.full_name} (#{new_player.salary}) now starting at right field for the #{self.full_name}, #{old_player.full_name} (#{old_player.salary}) moved to the bench."
      update_attributes(:right_field => new_player.id)
    end
    self.save!
  end

  # Displays the full name of the team, along with either the name of the team's user or "unowned"
  def full_name_with_user
    user ? full_name + ' (' + user.name + ')' : full_name + ' (unowned)'
  end

  # Creates an error if the team has more than one player at the same position
  def players_must_not_be_at_same_position
    positions = [designated_hitter, catcher, first_base,
                    second_base, third_base, shortstop,
                    left_field, center_field, right_field].compact
    if Team.count < 2 && positions.uniq.length != positions.length # Team.count < 2 because draft and free agent "teams" (ids 1 and 2, respectively) can have multiple players at a position
      errors.add(:base, "You have more than one player at the same position!")
    end

  end

  def get_total_payroll
    payroll = 0
    players.each do |player|
      if player.retired == 0
        payroll += player.salary
      end
    end
    payroll
  end

  def get_batters
    batters = []
    players.each do |player|
      if player.position != "P" && player.retired != 1 && player.level == "Active"
        batters.push(player)
      end
    end
    batters
  end

  def get_pitchers
    pitchers = []
    players.each do |player|
      if player.position == "P" && player.retired != 1 && player.level == "Active"
        pitchers.push(player)
      end
    end
    pitchers
  end

  # Takes the streak attribute and formats it so it looks nice on the page
  def streak_display
    case streak
    when 0
      "N/A"
    when 1..10000
      "W#{streak}"
    when -10000..-1
      "L#{streak*-1}"
    end
  end

  # Returns the Player that is the team's current starting pitcher
  def starting_pitcher
    case rotation_position
    when 1
      Player.find(sp1)
    when 2
      Player.find(sp2)
    when 3
      Player.find(sp3)
    when 4
      Player.find(sp4)
    when 5
      Player.find(sp5)
    end
  end

  # Returns the next rotation position (a number from 1 to 5)
  def increment_rotation
    new_rotation_position = rotation_position + 1
    if new_rotation_position > 5
      new_rotation_position = 1
    end
    new_rotation_position
  end

  # Returns the desired position abbreviation.
  def position_name(index)
    position_names = ['DH', 'C', '1B', '2B', '3B', 'SS', 'LF', 'CF', 'RF']
    position_names[index]
  end

  def get_dates_array(row_index, month, year)
    cal_dates = []
    date_array = nil
    case month
    when "April"
      date_array = Date.parse("1st April #{year}")..(Date.parse("1st May #{year}") - 1)
    when "May"
      date_array = Date.parse("1st May #{year}")..(Date.parse("1st June #{year}") - 1)
    when "June"
      date_array = Date.parse("1st June #{year}")..(Date.parse("1st July #{year}") - 1)
    when "July"
      date_array = Date.parse("1st July #{year}")..(Date.parse("1st August #{year}") - 1)
    when "August"
      date_array = Date.parse("1st August #{year}")..(Date.parse("1st September #{year}") - 1)
    when "September"
      date_array = Date.parse("1st September #{year}")..(Date.parse("1st November #{year}") - 1)
    end

    row_count = 0

    if row_index == 0
      leading_empty_cells = 0
      first_date = date_array.first
      if first_date.monday?
        leading_empty_cells = 0
      elsif first_date.tuesday?
        leading_empty_cells = 1
      elsif first_date.wednesday?
        leading_empty_cells = 2
      elsif first_date.thursday?
        leading_empty_cells = 3
      elsif first_date.friday?
        leading_empty_cells = 4
      elsif first_date.saturday?
        leading_empty_cells = 5
      else
        leading_empty_cells = 6
      end
      leading_empty_cells.times do
        cal_dates.push(nil)
      end
    end

    date_array.each do |date|
      if row_index == row_count
        cal_dates.push(date)
      end
      if date.sunday?
        row_count += 1
      end
    end
    cal_dates
  end

  # returns the player currently playing the given position (in abbreviated form)
  def find_player_by_position_abbrev(abbrev)
    case abbrev
    when "C"
      Player.find(catcher)
    when "DH"
      Player.find(designated_hitter)
    when "1B"
      Player.find(first_base)
    when "2B"
      Player.find(second_base)
    when "3B"
      Player.find(third_base)
    when "SS"
      Player.find(shortstop)
    when "LF"
      Player.find(left_field)
    when "CF"
      Player.find(center_field)
    when "RF"
      Player.find(right_field)
    else
      nil
    end
  end

  # returns the Player who is currently at the specified lineup position.
  def find_player_by_lineup_index(lineup_index)
    case lineup_index
    when 1
      find_player_by_position_abbrev(lineup1)
    when 2
      find_player_by_position_abbrev(lineup2)
    when 3
      find_player_by_position_abbrev(lineup3)
    when 4
      find_player_by_position_abbrev(lineup4)
    when 5
      find_player_by_position_abbrev(lineup5)
    when 6
      find_player_by_position_abbrev(lineup6)
    when 7
      find_player_by_position_abbrev(lineup7)
    when 8
      find_player_by_position_abbrev(lineup8)
    when 9
      find_player_by_position_abbrev(lineup9)
    else
      nil
    end
  end

  def find_pitcher_by_role_abbrev(abbrev)
    case abbrev
    when "sp1"
      Player.find(sp1)
    when "sp2"
      Player.find(sp2)
    when "sp3"
      Player.find(sp3)
    when "sp4"
      Player.find(sp4)
    when "sp5"
      Player.find(sp5)
    when "lr"
      Player.find(lr)
    when "mr1"
      Player.find(mr1)
    when "mr2"
      Player.find(mr2)
    when "mr3"
      Player.find(mr3)
    when "su1"
      Player.find(su1)
    when "su2"
      Player.find(su2)
    when "cl"
      Player.find(cl)
    end
  end

  # Returns the Player currently playing at the specified position
  def player_at_position(index)
    positions = [designated_hitter, catcher, first_base,
                    second_base, third_base, shortstop,
                    left_field, center_field, right_field]
    if index.nil?
      '--'
    else
      id = positions[index]
    end

    if Player.exists?(id)
      player_at_position = Player.find(id)
    else
      '--'
    end
    player_at_position
  end

  # Returns the Player currently batting at the specified lineup position
  def find_batting_order(lineup_position)
    lineup_ids = [lineup1, lineup2, lineup3, lineup4,
                  lineup5, lineup6, lineup7, lineup8,
                  lineup9]
    if Player.exists?(lineup_ids[lineup_position])
      Player.find(lineup_ids[lineup_position])
    else
      nil
    end
  end

  # Returns the Player currently playing at the specified fielding position
  def find_player_at_position(position)
    position_ids = [designated_hitter, catcher, first_base, second_base,
                  third_base, shortstop, left_field, center_field,
                  right_field]
    if Player.exists?(position_ids[position])
      Player.find(position_ids[position])
    else
      nil
    end
  end

  # Returns the id of the Player playing at the specified fielding position.
  def find_position_id(position)
    position_ids = [designated_hitter, catcher, first_base, second_base,
                  third_base, shortstop, left_field, center_field,
                  right_field]
    if Player.exists?(position_ids[position])
      Player.find(position_ids[position]).id
    else
      nil
    end
  end

  # Returns the id of the Player currently batting in the specified lineup position
  def find_batting_order_id(lineup_position)
    lineup_ids = [lineup1, lineup2, lineup3, lineup4,
                  lineup5, lineup6, lineup7, lineup8,
                  lineup9]
    if Player.exists?(lineup_ids[lineup_position])
      Player.find(lineup_ids[lineup_position]).id
    else
      nil
    end
  end

  # Returns the fielding position of the player currently batting in the specified lineup position.
  def find_position(lineup_position)
    lineup_ids = [lineup1, lineup2, lineup3, lineup4,
                  lineup5, lineup6, lineup7, lineup8,
                  lineup9]

    position_names = ['C', 'DH', '1B', '2B', '3B', 'SS', 'LF', 'CF', 'RF']

    position_names[lineup_ids[lineup_position]]
  end

  # Returns the Player currently batting in the specified lineup position.
  def find_player_by_position(lineup_position)
    lineup_ids = [lineup1, lineup2, lineup3, lineup4,
                  lineup5, lineup6, lineup7, lineup8,
                  lineup9]

    position_ids = [catcher, designated_hitter, first_base, second_base,
                  third_base, shortstop, left_field, center_field,
                  right_field]
    if Player.exists?(position_ids[lineup_ids[lineup_position]])
      Player.find(position_ids[lineup_ids[lineup_position]])
    else
      nil
    end
  end

  # Returns the id of the Player currently batting in the specified lineup position.
  def find_player_by_position_id(lineup_position)
    lineup_ids = [lineup1, lineup2, lineup3, lineup4,
                  lineup5, lineup6, lineup7, lineup8,
                  lineup9]

    position_ids = [catcher, designated_hitter, first_base, second_base,
                  third_base, shortstop, left_field, center_field,
                  right_field]
    if Player.exists?(position_ids[lineup_ids[lineup_position]])
      Player.find(position_ids[lineup_ids[lineup_position]]).id
    else
      nil
    end
  end

  # Returns the id of the specified lineup position.
  def find_lineup_index(lineup_position)
    lineup_ids = [lineup1, lineup2, lineup3, lineup4,
                  lineup5, lineup6, lineup7, lineup8,
                  lineup9]

    lineup_ids[lineup_position]
  end

  # Given a player id, find that player's current pitching role on the team (as a formatted string)
  def find_pitching_role_of_player_formatted(player_id)
    case player_id
    when sp1, sp2, sp3, sp4, sp5
      "Starter"
    when lr
      "Long Relief"
    when mr1, mr2, mr3
      "Middle Relief"
    when su1, su2
      "Setup"
    when cl
      "Closer"
    else ""
    end
  end

  # Given a player id, find that player's current pitching role on the team
  def find_pitching_role_of_player(player_id)
    case player_id
    when sp1
      "SP1"
    when sp2
      "SP2"
    when sp3
      "SP3"
    when sp4
      "SP4"
    when sp5
      "SP5"
    when lr
      "LR"
    when mr1
      "MR1"
    when mr2
      "MR2"
    when mr3
      "MR3"
    when su1
      "SU1"
    when su2
      "SU2"
    when cl
      "CL"
    else ""
    end
  end

  # Returns an array of players in the starting lineup
  def get_lineup
    lineup = [
      find_player_by_lineup_index(1),
      find_player_by_lineup_index(2),
      find_player_by_lineup_index(3),
      find_player_by_lineup_index(4),
      find_player_by_lineup_index(5),
      find_player_by_lineup_index(6),
      find_player_by_lineup_index(7),
      find_player_by_lineup_index(8),
      find_player_by_lineup_index(9)
    ]
  end

  # Given a player id, find that player's current position on the team, abbreviated
  def find_position_abbreviation_of_player(player_id)
    case player_id
    when catcher
      "C"
    when designated_hitter
      "DH"
    when first_base
      "1B"
    when second_base
      "2B"
    when third_base
      "3B"
    when shortstop
      "SS"
    when left_field
      "LF"
    when center_field
      "CF"
    when right_field
      "RF"
    else
      "BN"
    end
  end

  # Given a player id, find that player's current position on the team
  def find_position_of_player(player_id)
    case player_id
    when catcher
      ", C"
    when designated_hitter
      ", DH"
    when first_base
      ", 1B"
    when second_base
      ", 2B"
    when third_base
      ", 3B"
    when shortstop
      ", SS"
    when left_field
      ", LF"
    when center_field
      ", CF"
    when right_field
      ", RF"
    else
      ", " + find_pitching_role_of_player(player_id)
    end
  end

  # returns true if a player is currently in the starting lineup
  def is_in_starting_lineup(player_id)
    case player_id
    when catcher, designated_hitter, first_base, second_base, third_base,
      shortstop, left_field, center_field, right_field
      true
    else
      false
    end
  end

  # Where does this player hit in the lineup?
  def find_lineup_position_of_player(player_id)
    case find_position_abbreviation_of_player(player_id)
    when lineup1
      1
    when lineup2
      2
    when lineup3
      3
    when lineup4
      4
    when lineup5
      5
    when lineup6
      6
    when lineup7
      7
    when lineup8
      8
    when lineup9
      9
    end
  end

  # Find the name of the position of a player in the specified lineup position.
  def find_position_name(lineup_position)
    lineup_ids = [lineup1, lineup2, lineup3, lineup4,
                  lineup5, lineup6, lineup7, lineup8,
                  lineup9]

    position_names = ['catcher', 'designated_hitter', 'first_base', 'second_base',
                      'third_base', 'shortstop', 'left_field', 'center_field',
                      'right_field']
    position_names[lineup_ids[lineup_position]]
  end

end
