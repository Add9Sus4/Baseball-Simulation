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

  def find_bench(bench_position)
    bench_ids = [bench1, bench2, bench3, bench4]
    if Player.exists?(bench_ids[bench_position])
      Player.find(bench_ids[bench_position])
    else
      nil
    end
  end

  def find_bench_id(bench_position)
    bench_ids = [bench1, bench2, bench3, bench4]
    if Player.exists?(bench_ids[bench_position])
      Player.find(bench_ids[bench_position]).id
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
                  puts "lineup_ids: #{lineup_ids}"
    id = lineup_ids[lineup_position]
    puts "finding player at lineup position #{lineup_position}"
    puts "#{id} is the id "
    if id.nil?
      '--'
    else
      position_ids = [designated_hitter, catcher, first_base,
                      second_base, third_base, shortstop,
                      left_field, center_field, right_field,
                      bench1, bench2, bench3, bench4]
      position_names = ['DH', 'C', '1B', '2B', '3B', 'SS', 'LF', 'CF', 'RF',
                        'BN', 'BN', 'BN', 'BN']
      player_id = position_ids.index(id)
      if player_id.nil?
        '--'
      else
        position_names[player_id]
      end
    end

  end


end
