class AddWebGemsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :web_gems, :integer
    add_column :season_fielding_stats, :web_gems, :integer
    add_column :players, :anti_web_gems, :integer
    add_column :season_fielding_stats, :anti_web_gems, :integer
  end
end
