class AddPlayoffWinsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :division_series_wins, :integer
    add_column :season_team_stats, :division_series_wins, :integer
    add_column :teams, :championship_series_wins, :integer
    add_column :season_team_stats, :championship_series_wins, :integer
    add_column :teams, :world_series_wins, :integer
    add_column :season_team_stats, :world_series_wins, :integer
  end
end
