class Team < ActiveRecord::Base
  validates :city, :name, :league, :division, :stadium, :capacity, presence: true
  validate :players_must_not_be_at_same_position
  has_many :players, :dependent => :destroy
  accepts_nested_attributes_for :players

  MAX_PLAYERS = 13

  def full_name
    city + ' ' + name
  end

  def players_must_not_be_at_same_position
    positions = [designated_hitter, catcher, first_base,
                    second_base, third_base, shortstop,
                    left_field, center_field, right_field].compact
    if positions.uniq.length != positions.length
      errors.add(:base, "You have more than one player at the same position!")
    end

  end

  def position_name(index)
    position_names = ['DH', 'C', '1B', '2B', '3B', 'SS', 'LF', 'CF', 'RF']
    position_names[index]
  end

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

  def find_position(lineup_position)
    lineup_ids = [lineup1, lineup2, lineup3, lineup4,
                  lineup5, lineup6, lineup7, lineup8,
                  lineup9]

    position_names = ['C', 'DH', '1B', '2B', '3B', 'SS', 'LF', 'CF', 'RF']

    position_names[lineup_ids[lineup_position]]
  end

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

  def find_lineup_index(lineup_position)
    lineup_ids = [lineup1, lineup2, lineup3, lineup4,
                  lineup5, lineup6, lineup7, lineup8,
                  lineup9]

    lineup_ids[lineup_position]
  end

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
