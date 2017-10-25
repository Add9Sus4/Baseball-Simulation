class AddLineupPositionToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :lineup_position, :integer
  end
end
