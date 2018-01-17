class AddAppropriateStatsToSeasonTeamStats < ActiveRecord::Migration
  def change
    add_column :season_team_stats, :team_id, :integer
    add_column :season_team_stats, :season_id, :integer
    add_column :season_team_stats, :wins, :integer
    add_column :season_team_stats, :losses, :integer
    add_column :season_team_stats, :runs_scored, :integer
    add_column :season_team_stats, :runs_allowed, :integer
  end
end
