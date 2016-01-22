class Team < ActiveRecord::Base
  attr_accessor :position_names, :jajaja
  validates :city, :name, :league, :division, :stadium, :capacity, presence: true
  has_many :players, :dependent => :destroy

  def initialize
    jajaja = "2"
  end

  def full_name
    city + ' ' + name
  end



  def position(index)
    position_ids = [designated_hitter_id, catcher_id, first_base_id,
                    second_base_id, third_base_id, shortstop_id,
                    left_field_id, center_field_id, right_field_id,
                    bench1_id, bench2_id, bench3_id, bench4_id]
    id = position_ids[index]
    position_names = ['DH', 'C', '1B', '2B', '3B', 'SS', 'LF', 'CF', 'RF',
                      'BN', 'BN', 'BN', 'BN']

    if Player.exists?(id)
      player = Player.find(id).full_name
    else
      player = 'Empty'
    end

    position_names[index] + ": " + player
  end

  def position_array
    positions = Array.new(13)
    count = 0
    position_ids.each do |id|
      if Player.exists?(id)
        positions[count] = Player.find(id)
      else
        positions[count] = 'Empty'
      end
      count += 1
    end
    positions
  end

end
