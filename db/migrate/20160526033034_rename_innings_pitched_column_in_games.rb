class RenameInningsPitchedColumnInGames < ActiveRecord::Migration
  def change
    rename_column :games, :home_innings_pitched, :home_outs_recorded
    rename_column :games, :away_innings_pitched, :away_outs_recorded
    add_column :games, :away_stolen_bases, :string
  end
end
