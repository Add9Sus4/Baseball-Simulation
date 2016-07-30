class AddRunsScoredAndRunsAllowedToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :runs_scored, :integer
    add_column :teams, :runs_allowed, :integer
  end
end
