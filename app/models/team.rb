# Team class.
class Team < ActiveRecord::Base

  attr_accessor :game_lineup_position, # what lineup spot is currently up
  :game_pitcher_list, # list of all pitchers that have pitched in the current game
  :game_score, # number of runs scored by this team in the current game
  :game_inning_scores, # string representing runs scored each inning, separated by '_'
  :in_line_for_loss, # if this team is losing, which pitcher would get the loss if the game ended now?
  :in_line_for_win, # if this team is winning, which pitcher woudl get the win if the game ended now?
  :game_lineup # string of ids representing the players in the lineup, in order, separated by '_'

  # A team must have all the following attributes when it is created:
  validates :city, :name, :league, :division, :stadium, :capacity, presence: true

  # A team cannot have more than one player at the same position
  validate :players_must_not_be_at_same_position

  # This line is necessary to establish the one-to-many relationship between team and player.
  # It also ensures that when a team is removed from the database, all of its players are also removed.
  has_many :players, :dependent => :destroy

  # This line is necessary so that when you edit the team, you can also edit players associated
  # with the team using the same form
  accepts_nested_attributes_for :players

  # This line is necessary to establish the one-to-many relationship between user and team.
  belongs_to :user

  # A team can have a maximum of 25 players.
  MAX_PLAYERS = 25

  # Displays the full name of the team
  def full_name
    city + ' ' + name
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
    if positions.uniq.length != positions.length
      errors.add(:base, "You have more than one player at the same position!")
    end

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
      puts "sp1: #{sp1}"
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

  # returns the player currently playing the given position (in abbreviated form)
  def find_player_id_by_position_abbrev(abbrev)
    case abbrev
    when "C"
      catcher
    when "DH"
      designated_hitter
    when "1B"
      first_base
    when "2B"
      second_base
    when "3B"
      third_base
    when "SS"
      shortstop
    when "LF"
      left_field
    when "CF"
      center_field
    when "RF"
      right_field
    else
      nil
    end
  end

  # returns the Player who is currently at the specified lineup position.
  def find_player_by_lineup_index(lineup_index)
    puts "finding player with lineup index #{lineup_index}"
    case lineup_index
    when 1
      find_player_id_by_position_abbrev(lineup1)
    when 2
      find_player_id_by_position_abbrev(lineup2)
    when 3
      find_player_id_by_position_abbrev(lineup3)
    when 4
      find_player_id_by_position_abbrev(lineup4)
    when 5
      find_player_id_by_position_abbrev(lineup5)
    when 6
      find_player_id_by_position_abbrev(lineup6)
    when 7
      find_player_id_by_position_abbrev(lineup7)
    when 8
      find_player_id_by_position_abbrev(lineup8)
    when 9
      find_player_id_by_position_abbrev(lineup9)
    else
      nil
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
