class AddWinningPitcherAndLosingPitcherToGames < ActiveRecord::Migration
  def change
    add_column :games, :winning_pitcher, :integer
    add_column :games, :losing_pitcher, :integer
  end
end
