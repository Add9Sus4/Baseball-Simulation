class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :home_team_id
      t.integer :away_team_id
      t.integer :attendance
      t.string :stadium_name
      t.string :home_lineup
      t.string :away_lineup
      t.string :home_atbats
      t.string :home_runs_scored
      t.string :home_hits
      t.string :home_doubles
      t.string :home_triples
      t.string :home_home_runs
      t.string :home_RBI
      t.string :home_walks
      t.string :home_strikeouts
      t.string :home_stolen_bases
      t.string :home_caught_stealing
      t.string :home_errors
      t.string :home_assists
      t.string :home_putouts
      t.string :home_chances
      t.string :away_atbats
      t.string :away_runs_scored
      t.string :away_hits
      t.string :away_doubles
      t.string :away_triples
      t.string :away_home_runs
      t.string :away_RBI
      t.string :away_walks
      t.string :away_strikeouts
      t.string :away_caught_stealing
      t.string :away_errors
      t.string :away_assists
      t.string :away_putouts
      t.string :away_chances
      t.string :home_pitchers
      t.string :away_pitchers
      t.string :home_innings_pitched
      t.string :home_hits_allowed
      t.string :home_runs_allowed
      t.string :home_earned_runs_allowed
      t.string :home_walks_allowed
      t.string :home_strikeouts_recorded
      t.string :home_home_runs_allowed
      t.string :home_total_pitches
      t.string :home_strikes_thrown
      t.string :home_balls_thrown
      t.string :home_intentional_walks_allowed
      t.string :away_innings_pitched
      t.string :away_hits_allowed
      t.string :away_runs_allowed
      t.string :away_earned_runs_allowed
      t.string :away_walks_allowed
      t.string :away_strikeouts_recorded
      t.string :away_home_runs_allowed
      t.string :away_total_pitches
      t.string :away_strikes_thrown
      t.string :away_balls_thrown
      t.string :away_intentional_walks_allowed
      t.integer :player_of_the_game

      t.timestamps null: false
    end
  end
end
