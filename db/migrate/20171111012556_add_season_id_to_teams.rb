class AddSeasonIdToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :season_id, :integer
  end
end
