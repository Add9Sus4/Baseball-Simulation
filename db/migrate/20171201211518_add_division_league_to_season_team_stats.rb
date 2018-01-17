class AddDivisionLeagueToSeasonTeamStats < ActiveRecord::Migration
  def change
    add_column :season_team_stats, :league, :text
    add_column :season_team_stats, :division, :text
  end
end
