class CreateSeasonTeamStats < ActiveRecord::Migration
  def change
    create_table :season_team_stats do |t|

      t.timestamps null: false
    end
  end
end
