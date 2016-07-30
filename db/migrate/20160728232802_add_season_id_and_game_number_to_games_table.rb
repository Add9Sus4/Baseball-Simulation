class AddSeasonIdAndGameNumberToGamesTable < ActiveRecord::Migration
  def change
    add_column :games, :season_id, :integer
    add_column :games, :game_number, :integer
  end
end
