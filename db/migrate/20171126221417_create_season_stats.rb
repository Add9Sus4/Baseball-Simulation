class CreateSeasonStats < ActiveRecord::Migration
  def change
    create_table :season_stats do |t|

      t.timestamps null: false
    end
  end
end
