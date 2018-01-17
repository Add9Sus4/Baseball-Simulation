class CreateSeasonFieldingStats < ActiveRecord::Migration
  def change
    create_table :season_fielding_stats do |t|

      t.timestamps null: false
    end
  end
end
