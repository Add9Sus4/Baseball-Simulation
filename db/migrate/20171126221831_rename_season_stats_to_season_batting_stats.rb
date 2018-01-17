class RenameSeasonStatsToSeasonBattingStats < ActiveRecord::Migration
  def change
    rename_table :season_stats, :season_batting_stats
  end
end
