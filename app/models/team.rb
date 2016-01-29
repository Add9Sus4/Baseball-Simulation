class Team < ActiveRecord::Base
  validates :city, :name, :league, :division, :stadium, :capacity, presence: true
  validate :players_must_not_be_at_same_position
  has_many :players, :dependent => :destroy
  accepts_nested_attributes_for :players

  def full_name
    city + ' ' + name
  end

  def players_must_not_be_at_same_position
    positions = [designated_hitter, catcher, first_base,
                    second_base, third_base, shortstop,
                    left_field, center_field, right_field,
                    bench1, bench2, bench3, bench4].compact
    if positions.uniq.length != positions.length
      errors.add(:base, "You have more than one player at the same position!")
    end

  end

  def position_name(index)
    position_names = ['DH', 'C', '1B', '2B', '3B', 'SS', 'LF', 'CF', 'RF',
                      'BN', 'BN', 'BN', 'BN']
    position_names[index]
  end

  def player_at_position(index)
    positions = [designated_hitter, catcher, first_base,
                    second_base, third_base, shortstop,
                    left_field, center_field, right_field,
                    bench1, bench2, bench3, bench4]
    id = positions[index]
    if Player.exists?(id)
      player_at_position = Player.find(id)
    else
      player_at_position = ''
    end
    player_at_position
  end

  def find_position(player_id)
    position_ids = [designated_hitter, catcher, first_base,
                    second_base, third_base, shortstop,
                    left_field, center_field, right_field,
                    bench1, bench2, bench3, bench4]
    position_names = ['DH', 'C', '1B', '2B', '3B', 'SS', 'LF', 'CF', 'RF',
                      'BN', 'BN', 'BN', 'BN']
    position_names[position_ids.index(player_id)]
  end


end
