class AddStatsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :atbats, :integer
    add_column :players, :runs, :integer
    add_column :players, :hits, :integer
    add_column :players, :doubles, :integer
    add_column :players, :triples, :integer
    add_column :players, :home_runs, :integer
    add_column :players, :rbi, :integer
    add_column :players, :walks, :integer
    add_column :players, :strikeouts, :integer
    add_column :players, :stolen_bases, :integer
    add_column :players, :caught_stealing, :integer
    add_column :players, :errors_committed, :integer
    add_column :players, :assists, :integer
    add_column :players, :putouts, :integer
    add_column :players, :chances, :integer
    add_column :players, :outs_recorded, :integer
    add_column :players, :hits_allowed, :integer
    add_column :players, :runs_allowed, :integer
    add_column :players, :earned_runs_allowed, :integer
    add_column :players, :walks_allowed, :integer
    add_column :players, :strikeouts_recorded, :integer
    add_column :players, :home_runs_allowed, :integer
    add_column :players, :total_pitches, :integer
    add_column :players, :strikes_thrown, :integer
    add_column :players, :balls_thrown, :integer
    add_column :players, :intentional_walks_allowed, :integer
  end
end
