class CreateSeasonPitchingStats < ActiveRecord::Migration
  def change
    create_table :season_pitching_stats do |t|

      t.timestamps null: false
    end
  end
end
