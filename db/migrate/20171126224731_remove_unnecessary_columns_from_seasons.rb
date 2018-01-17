class RemoveUnnecessaryColumnsFromSeasons < ActiveRecord::Migration
  def change
    remove_column :seasons, :next_game
    remove_column :seasons, :simulating
  end
end
